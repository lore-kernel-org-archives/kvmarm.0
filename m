From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH v3 00/41] Optimize KVM/ARM for VHE systems
Date: Fri, 2 Feb 2018 11:05:40 +0100
Message-ID: <517cf93e-dd7b-33e1-d89d-3b7372ab8771@semihalf.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <f886a2fd-e0f0-3252-9f6e-00422d895e9f@semihalf.com>
 <20180201161536.weg5f5kivjtleauc@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180201161536.weg5f5kivjtleauc@yury-thinkpad>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01.02.2018 17:15, Yury Norov wrote:
> On Thu, Feb 01, 2018 at 02:57:59PM +0100, Tomasz Nowicki wrote:
>> Hi Christoffer,
>>
>> I created simple module for VM kernel. It is spinning on PSCI version
>> hypercall to measure the base exit cost as you suggested. Also, I measured
>> CPU cycles for each loop and here are my results:
>>
>> My setup:
>> 1-socket ThunderX2 running VM - 1VCPU
>>
>> Tested baselines:
>> a) host kernel v4.15-rc3 and VM kernel v4.15-rc3
>> b) host kernel v4.15-rc3 + vhe-optimize-v3-with-fixes and VM kernel
>> v4.15-rc3
>>
>> Module was loaded from VM and the results are presented in [%] relative to
>> average CPU cycles spending on PSCI version hypercall for vanilla VHE host
>> kernel v4.15-rc3:
>>
>>               VHE  |  nVHE
>> =========================
>> baseline a)  100% |  130%
>> =========================
>> baseline a)  36%  |  123%
>>
>> So I confirm significant performance improvement, especially for VHE case.
>> Additionally, I run network throughput tests with vhost-net but for that
>> case no differences.
> 
> Hi Tomasz,
> 
> Can you share your test?
> 

Yes:

#include <linux/arm-smccc.h>
#include <linux/err.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/kthread.h>
#include <linux/mm.h>
#include <linux/module.h>
#include <linux/psci.h>
#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>

#include <uapi/linux/psci.h>

#define SAMPLE_N	(10000UL)
#define SAMPLES		(500)
#define CPU_PINNED	(10)

static struct task_struct *kvm_bench_task;

static unsigned long __invoke_psci_fn_hvc(unsigned long function_id,
			unsigned long arg0, unsigned long arg1,
			unsigned long arg2)
{
	struct arm_smccc_res res;

	arm_smccc_hvc(function_id, arg0, arg1, arg2, 0, 0, 0, 0, &res);
	return res.a0;
}

static u32 psci_get_version(void)
{
	return __invoke_psci_fn_hvc(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
}

static inline u64 get_cycles_custom(void)
{
	register u64 c;
	__asm__ volatile("mrs %0, cntvct_el0" : "=r"(c));
	return c;
}

static int kvm_bench_kthread(void *none)
{
	int test_iter, out = SAMPLES;
	u64 time_before, time;
         u32 ver = psci_get_version();

	printk(KERN_INFO "Starting kvm exit cost test, using PSCI get version 
hypercall");
	printk(KERN_INFO "Obtained PSCIv%d.%d\n", PSCI_VERSION_MAJOR(ver),
	       PSCI_VERSION_MINOR(ver));

	for (test_iter = 0;; test_iter++) {
		if (!(test_iter % SAMPLE_N)) {
			time_before = get_cycles_custom();
		}

		psci_get_version();

		if (!(test_iter % SAMPLE_N)) {
			while (!out--) {
				kvm_bench_task = NULL;
				do_exit(0);
			}
			time = get_cycles_custom() - time_before;
			printk(KERN_INFO "iter takes %llu cycles. \n", time);
			if (kthread_should_stop())
				break;
			schedule();
		}
	}

	return 0;
}

static int __init kvm_bench_init(void)
{
	int err;

	printk(KERN_INFO "KVM exit cost benchmark\n");

	kvm_bench_task = kthread_create(kvm_bench_kthread, NULL, "kvm_test");
	if(IS_ERR(kvm_bench_task)) {
		printk(KERN_INFO "Unable to start thread.\n");
		err = PTR_ERR(kvm_bench_task);
		return err;
	}
	kthread_bind(kvm_bench_task, CPU_PINNED);
	wake_up_process(kvm_bench_task);
	return 0;
}

static void __exit kvm_bench_cleanup(void)
{
	printk(KERN_INFO "KVM benchmark cleaning up\n");
	if (kvm_bench_task)
		kthread_stop(kvm_bench_task);
}

module_init(kvm_bench_init);
module_exit(kvm_bench_cleanup);


Thanks,
Tomasz
