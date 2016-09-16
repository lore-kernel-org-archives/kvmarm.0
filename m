From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 16 Sep 2016 16:42:18 +0800
Message-ID: <201609161647.A197p5ym%fengguang.wu@intel.com>
References: <1473981320-25387-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Transfer-Encoding: 8bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6FF940FA6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 04:34:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hFl-RKJor1Op for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 04:34:36 -0400 (EDT)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 900DE40F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 04:34:35 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1473981320-25387-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm@vger.kernel.org, kbuild-all@01.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Alexander,

[auto build test ERROR on kvm/linux-next]
[also build test ERROR on v4.8-rc6 next-20160916]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Alexander-Graf/KVM-arm-arm64-Route-vtimer-events-to-user-space/20160916-073838
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
config: arm64-allmodconfig (attached as .config)
compiler: aarch64-linux-gnu-gcc (Debian 5.4.0-6) 5.4.0 20160609
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=arm64 

All error/warnings (new ones prefixed by >>):

   arch/arm64/kvm/../../../arch/arm/kvm/arm.c: In function 'kvm_arch_vcpu_ioctl':
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1000:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
    ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1016:12: error: invalid storage class for function 'kvm_vm_ioctl_set_device_addr'
    static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
               ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1077:13: error: invalid storage class for function 'cpu_init_hyp_mode'
    static void cpu_init_hyp_mode(void *dummy)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1098:13: error: invalid storage class for function 'cpu_hyp_reinit'
    static void cpu_hyp_reinit(void)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1112:13: error: invalid storage class for function 'cpu_hyp_reset'
    static void cpu_hyp_reset(void)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1119:13: error: invalid storage class for function '_kvm_arch_hardware_enable'
    static void _kvm_arch_hardware_enable(void *discard)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1133:13: error: invalid storage class for function '_kvm_arch_hardware_disable'
    static void _kvm_arch_hardware_disable(void *discard)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1147:12: error: invalid storage class for function 'hyp_init_cpu_pm_notifier'
    static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
               ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1180:19: error: initializer element is not constant
     .notifier_call = hyp_init_cpu_pm_notifier,
                      ^
   arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1180:19: note: (near initialization for 'hyp_init_cpu_pm_nb.notifier_call')
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1183:20: error: invalid storage class for function 'hyp_cpu_pm_init'
    static void __init hyp_cpu_pm_init(void)
                       ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1187:20: error: invalid storage class for function 'hyp_cpu_pm_exit'
    static void __init hyp_cpu_pm_exit(void)
                       ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1200:13: error: invalid storage class for function 'teardown_common_resources'
    static void teardown_common_resources(void)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1205:12: error: invalid storage class for function 'init_common_resources'
    static int init_common_resources(void)
               ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1216:12: error: invalid storage class for function 'init_subsystems'
    static int init_subsystems(void)
               ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1263:13: error: invalid storage class for function 'teardown_hyp_mode'
    static void teardown_hyp_mode(void)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1276:12: error: invalid storage class for function 'init_vhe_mode'
    static int init_vhe_mode(void)
               ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1289:12: error: invalid storage class for function 'init_hyp_mode'
    static int init_hyp_mode(void)
               ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1379:13: error: invalid storage class for function 'check_kvm_target_cpu'
    static void check_kvm_target_cpu(void *ret)
                ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1448:12: error: invalid storage class for function 'arm_init'
    static int arm_init(void)
               ^
   In file included from include/linux/printk.h:5:0,
                    from include/linux/kernel.h:13,
                    from include/linux/cpu_pm.h:21,
                    from arch/arm64/kvm/../../../arch/arm/kvm/arm.c:19:
   arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1454:13: error: initializer element is not constant
    module_init(arm_init);
                ^
   include/linux/init.h:182:58: note: in definition of macro '__define_initcall'
     __attribute__((__section__(".initcall" #id ".init"))) = fn; \
                                                             ^
   include/linux/init.h:217:24: note: in expansion of macro 'device_initcall'
    #define __initcall(fn) device_initcall(fn)
                           ^
   include/linux/module.h:86:24: note: in expansion of macro '__initcall'
    #define module_init(x) __initcall(x);
                           ^
>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:1454:1: note: in expansion of macro 'module_init'
    module_init(arm_init);
    ^

vim +/kvm_vm_ioctl_set_device_addr +1016 arch/arm64/kvm/../../../arch/arm/kvm/arm.c

53c810c36 Mario Smarduch    2015-01-15   994   *
53c810c36 Mario Smarduch    2015-01-15   995   *   1. Take a snapshot of the bit and clear it if needed.
53c810c36 Mario Smarduch    2015-01-15   996   *   2. Write protect the corresponding page.
53c810c36 Mario Smarduch    2015-01-15   997   *   3. Copy the snapshot to the userspace.
53c810c36 Mario Smarduch    2015-01-15   998   *   4. Flush TLB's if needed.
53c810c36 Mario Smarduch    2015-01-15   999   */
749cf76c5 Christoffer Dall  2013-01-20 @1000  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
749cf76c5 Christoffer Dall  2013-01-20  1001  {
53c810c36 Mario Smarduch    2015-01-15  1002  	bool is_dirty = false;
53c810c36 Mario Smarduch    2015-01-15  1003  	int r;
53c810c36 Mario Smarduch    2015-01-15  1004  
53c810c36 Mario Smarduch    2015-01-15  1005  	mutex_lock(&kvm->slots_lock);
53c810c36 Mario Smarduch    2015-01-15  1006  
53c810c36 Mario Smarduch    2015-01-15  1007  	r = kvm_get_dirty_log_protect(kvm, log, &is_dirty);
53c810c36 Mario Smarduch    2015-01-15  1008  
53c810c36 Mario Smarduch    2015-01-15  1009  	if (is_dirty)
53c810c36 Mario Smarduch    2015-01-15  1010  		kvm_flush_remote_tlbs(kvm);
53c810c36 Mario Smarduch    2015-01-15  1011  
53c810c36 Mario Smarduch    2015-01-15  1012  	mutex_unlock(&kvm->slots_lock);
53c810c36 Mario Smarduch    2015-01-15  1013  	return r;
749cf76c5 Christoffer Dall  2013-01-20  1014  }
749cf76c5 Christoffer Dall  2013-01-20  1015  
3401d5469 Christoffer Dall  2013-01-23 @1016  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
3401d5469 Christoffer Dall  2013-01-23  1017  					struct kvm_arm_device_addr *dev_addr)
3401d5469 Christoffer Dall  2013-01-23  1018  {
330690cdc Christoffer Dall  2013-01-21  1019  	unsigned long dev_id, type;
330690cdc Christoffer Dall  2013-01-21  1020  
330690cdc Christoffer Dall  2013-01-21  1021  	dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
330690cdc Christoffer Dall  2013-01-21  1022  		KVM_ARM_DEVICE_ID_SHIFT;
330690cdc Christoffer Dall  2013-01-21  1023  	type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
330690cdc Christoffer Dall  2013-01-21  1024  		KVM_ARM_DEVICE_TYPE_SHIFT;
330690cdc Christoffer Dall  2013-01-21  1025  
330690cdc Christoffer Dall  2013-01-21  1026  	switch (dev_id) {
330690cdc Christoffer Dall  2013-01-21  1027  	case KVM_ARM_DEVICE_VGIC_V2:
c7da6fa43 Pavel Fedin       2015-12-18  1028  		if (!vgic_present)
c7da6fa43 Pavel Fedin       2015-12-18  1029  			return -ENXIO;
ce01e4e88 Christoffer Dall  2013-09-23  1030  		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
330690cdc Christoffer Dall  2013-01-21  1031  	default:
3401d5469 Christoffer Dall  2013-01-23  1032  		return -ENODEV;
3401d5469 Christoffer Dall  2013-01-23  1033  	}
330690cdc Christoffer Dall  2013-01-21  1034  }
3401d5469 Christoffer Dall  2013-01-23  1035  
749cf76c5 Christoffer Dall  2013-01-20  1036  long kvm_arch_vm_ioctl(struct file *filp,
749cf76c5 Christoffer Dall  2013-01-20  1037  		       unsigned int ioctl, unsigned long arg)
749cf76c5 Christoffer Dall  2013-01-20  1038  {
3401d5469 Christoffer Dall  2013-01-23  1039  	struct kvm *kvm = filp->private_data;
3401d5469 Christoffer Dall  2013-01-23  1040  	void __user *argp = (void __user *)arg;
3401d5469 Christoffer Dall  2013-01-23  1041  
3401d5469 Christoffer Dall  2013-01-23  1042  	switch (ioctl) {
5863c2ce7 Marc Zyngier      2013-01-21  1043  	case KVM_CREATE_IRQCHIP: {
a28ebea2a Christoffer Dall  2016-08-09  1044  		int ret;
c7da6fa43 Pavel Fedin       2015-12-18  1045  		if (!vgic_present)
c7da6fa43 Pavel Fedin       2015-12-18  1046  			return -ENXIO;
a28ebea2a Christoffer Dall  2016-08-09  1047  		mutex_lock(&kvm->lock);
a28ebea2a Christoffer Dall  2016-08-09  1048  		ret = kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
a28ebea2a Christoffer Dall  2016-08-09  1049  		mutex_unlock(&kvm->lock);
a28ebea2a Christoffer Dall  2016-08-09  1050  		return ret;
5863c2ce7 Marc Zyngier      2013-01-21  1051  	}
3401d5469 Christoffer Dall  2013-01-23  1052  	case KVM_ARM_SET_DEVICE_ADDR: {
3401d5469 Christoffer Dall  2013-01-23  1053  		struct kvm_arm_device_addr dev_addr;
3401d5469 Christoffer Dall  2013-01-23  1054  
3401d5469 Christoffer Dall  2013-01-23  1055  		if (copy_from_user(&dev_addr, argp, sizeof(dev_addr)))
3401d5469 Christoffer Dall  2013-01-23  1056  			return -EFAULT;
3401d5469 Christoffer Dall  2013-01-23  1057  		return kvm_vm_ioctl_set_device_addr(kvm, &dev_addr);
3401d5469 Christoffer Dall  2013-01-23  1058  	}
42c4e0c77 Anup Patel        2013-09-30  1059  	case KVM_ARM_PREFERRED_TARGET: {
42c4e0c77 Anup Patel        2013-09-30  1060  		int err;
42c4e0c77 Anup Patel        2013-09-30  1061  		struct kvm_vcpu_init init;
42c4e0c77 Anup Patel        2013-09-30  1062  
42c4e0c77 Anup Patel        2013-09-30  1063  		err = kvm_vcpu_preferred_target(&init);
42c4e0c77 Anup Patel        2013-09-30  1064  		if (err)
42c4e0c77 Anup Patel        2013-09-30  1065  			return err;
42c4e0c77 Anup Patel        2013-09-30  1066  
42c4e0c77 Anup Patel        2013-09-30  1067  		if (copy_to_user(argp, &init, sizeof(init)))
42c4e0c77 Anup Patel        2013-09-30  1068  			return -EFAULT;
42c4e0c77 Anup Patel        2013-09-30  1069  
42c4e0c77 Anup Patel        2013-09-30  1070  		return 0;
42c4e0c77 Anup Patel        2013-09-30  1071  	}
3401d5469 Christoffer Dall  2013-01-23  1072  	default:
749cf76c5 Christoffer Dall  2013-01-20  1073  		return -EINVAL;
749cf76c5 Christoffer Dall  2013-01-20  1074  	}
3401d5469 Christoffer Dall  2013-01-23  1075  }
749cf76c5 Christoffer Dall  2013-01-20  1076  
d157f4a51 Marc Zyngier      2013-04-12 @1077  static void cpu_init_hyp_mode(void *dummy)
342cd0ab0 Christoffer Dall  2013-01-20  1078  {
dac288f7b Marc Zyngier      2013-05-14  1079  	phys_addr_t pgd_ptr;
342cd0ab0 Christoffer Dall  2013-01-20  1080  	unsigned long hyp_stack_ptr;
342cd0ab0 Christoffer Dall  2013-01-20  1081  	unsigned long stack_page;
342cd0ab0 Christoffer Dall  2013-01-20  1082  	unsigned long vector_ptr;
342cd0ab0 Christoffer Dall  2013-01-20  1083  
342cd0ab0 Christoffer Dall  2013-01-20  1084  	/* Switch from the HYP stub to our own HYP init vector */
5a677ce04 Marc Zyngier      2013-04-12  1085  	__hyp_set_vectors(kvm_get_idmap_vector());
342cd0ab0 Christoffer Dall  2013-01-20  1086  
dac288f7b Marc Zyngier      2013-05-14  1087  	pgd_ptr = kvm_mmu_get_httbr();
1436c1aa6 Christoph Lameter 2013-10-21  1088  	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
342cd0ab0 Christoffer Dall  2013-01-20  1089  	hyp_stack_ptr = stack_page + PAGE_SIZE;
a0bf9776c Ard Biesheuvel    2016-02-16  1090  	vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
342cd0ab0 Christoffer Dall  2013-01-20  1091  
12fda8123 Marc Zyngier      2016-06-30  1092  	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
35a2491a6 Marc Zyngier      2016-02-01  1093  	__cpu_init_stage2();
56c7f5e77 Alex Bennée       2015-07-07  1094  
56c7f5e77 Alex Bennée       2015-07-07  1095  	kvm_arm_init_debug();
342cd0ab0 Christoffer Dall  2013-01-20  1096  }
342cd0ab0 Christoffer Dall  2013-01-20  1097  
5f5560b1c James Morse       2016-03-30 @1098  static void cpu_hyp_reinit(void)
5f5560b1c James Morse       2016-03-30  1099  {
5f5560b1c James Morse       2016-03-30  1100  	if (is_kernel_in_hyp_mode()) {
5f5560b1c James Morse       2016-03-30  1101  		/*
67f691976 AKASHI Takahiro   2016-04-27  1102  		 * __cpu_init_stage2() is safe to call even if the PM
5f5560b1c James Morse       2016-03-30  1103  		 * event was cancelled before the CPU was reset.
5f5560b1c James Morse       2016-03-30  1104  		 */
67f691976 AKASHI Takahiro   2016-04-27  1105  		__cpu_init_stage2();
5f5560b1c James Morse       2016-03-30  1106  	} else {
5f5560b1c James Morse       2016-03-30  1107  		if (__hyp_get_vectors() == hyp_default_vectors)
5f5560b1c James Morse       2016-03-30  1108  			cpu_init_hyp_mode(NULL);
5f5560b1c James Morse       2016-03-30  1109  	}
5f5560b1c James Morse       2016-03-30  1110  }
5f5560b1c James Morse       2016-03-30  1111  
67f691976 AKASHI Takahiro   2016-04-27 @1112  static void cpu_hyp_reset(void)
67f691976 AKASHI Takahiro   2016-04-27  1113  {
12fda8123 Marc Zyngier      2016-06-30  1114  	if (!is_kernel_in_hyp_mode())
e537ecd7e Marc Zyngier      2016-06-30  1115  		__cpu_reset_hyp_mode(hyp_default_vectors,
e537ecd7e Marc Zyngier      2016-06-30  1116  				     kvm_get_idmap_start());
67f691976 AKASHI Takahiro   2016-04-27  1117  }
67f691976 AKASHI Takahiro   2016-04-27  1118  
67f691976 AKASHI Takahiro   2016-04-27 @1119  static void _kvm_arch_hardware_enable(void *discard)
d157f4a51 Marc Zyngier      2013-04-12  1120  {
67f691976 AKASHI Takahiro   2016-04-27  1121  	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
5f5560b1c James Morse       2016-03-30  1122  		cpu_hyp_reinit();
67f691976 AKASHI Takahiro   2016-04-27  1123  		__this_cpu_write(kvm_arm_hardware_enabled, 1);
67f691976 AKASHI Takahiro   2016-04-27  1124  	}
d157f4a51 Marc Zyngier      2013-04-12  1125  }
d157f4a51 Marc Zyngier      2013-04-12  1126  
67f691976 AKASHI Takahiro   2016-04-27  1127  int kvm_arch_hardware_enable(void)
67f691976 AKASHI Takahiro   2016-04-27  1128  {
67f691976 AKASHI Takahiro   2016-04-27  1129  	_kvm_arch_hardware_enable(NULL);
67f691976 AKASHI Takahiro   2016-04-27  1130  	return 0;
342cd0ab0 Christoffer Dall  2013-01-20  1131  }
342cd0ab0 Christoffer Dall  2013-01-20  1132  
67f691976 AKASHI Takahiro   2016-04-27 @1133  static void _kvm_arch_hardware_disable(void *discard)
67f691976 AKASHI Takahiro   2016-04-27  1134  {
67f691976 AKASHI Takahiro   2016-04-27  1135  	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
67f691976 AKASHI Takahiro   2016-04-27  1136  		cpu_hyp_reset();
67f691976 AKASHI Takahiro   2016-04-27  1137  		__this_cpu_write(kvm_arm_hardware_enabled, 0);
67f691976 AKASHI Takahiro   2016-04-27  1138  	}
67f691976 AKASHI Takahiro   2016-04-27  1139  }
67f691976 AKASHI Takahiro   2016-04-27  1140  
67f691976 AKASHI Takahiro   2016-04-27  1141  void kvm_arch_hardware_disable(void)
67f691976 AKASHI Takahiro   2016-04-27  1142  {
67f691976 AKASHI Takahiro   2016-04-27  1143  	_kvm_arch_hardware_disable(NULL);
67f691976 AKASHI Takahiro   2016-04-27  1144  }
d157f4a51 Marc Zyngier      2013-04-12  1145  
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1146  #ifdef CONFIG_CPU_PM
1fcf7ce0c Lorenzo Pieralisi 2013-08-05 @1147  static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1148  				    unsigned long cmd,
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1149  				    void *v)
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1150  {
67f691976 AKASHI Takahiro   2016-04-27  1151  	/*
67f691976 AKASHI Takahiro   2016-04-27  1152  	 * kvm_arm_hardware_enabled is left with its old value over
67f691976 AKASHI Takahiro   2016-04-27  1153  	 * PM_ENTER->PM_EXIT. It is used to indicate PM_EXIT should
67f691976 AKASHI Takahiro   2016-04-27  1154  	 * re-enable hyp.
67f691976 AKASHI Takahiro   2016-04-27  1155  	 */
67f691976 AKASHI Takahiro   2016-04-27  1156  	switch (cmd) {
67f691976 AKASHI Takahiro   2016-04-27  1157  	case CPU_PM_ENTER:
67f691976 AKASHI Takahiro   2016-04-27  1158  		if (__this_cpu_read(kvm_arm_hardware_enabled))
67f691976 AKASHI Takahiro   2016-04-27  1159  			/*
67f691976 AKASHI Takahiro   2016-04-27  1160  			 * don't update kvm_arm_hardware_enabled here
67f691976 AKASHI Takahiro   2016-04-27  1161  			 * so that the hardware will be re-enabled
67f691976 AKASHI Takahiro   2016-04-27  1162  			 * when we resume. See below.
67f691976 AKASHI Takahiro   2016-04-27  1163  			 */
67f691976 AKASHI Takahiro   2016-04-27  1164  			cpu_hyp_reset();
67f691976 AKASHI Takahiro   2016-04-27  1165  
67f691976 AKASHI Takahiro   2016-04-27  1166  		return NOTIFY_OK;
67f691976 AKASHI Takahiro   2016-04-27  1167  	case CPU_PM_EXIT:
67f691976 AKASHI Takahiro   2016-04-27  1168  		if (__this_cpu_read(kvm_arm_hardware_enabled))
67f691976 AKASHI Takahiro   2016-04-27  1169  			/* The hardware was enabled before suspend. */
5f5560b1c James Morse       2016-03-30  1170  			cpu_hyp_reinit();
67f691976 AKASHI Takahiro   2016-04-27  1171  
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1172  		return NOTIFY_OK;
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1173  
67f691976 AKASHI Takahiro   2016-04-27  1174  	default:
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1175  		return NOTIFY_DONE;
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1176  	}
67f691976 AKASHI Takahiro   2016-04-27  1177  }
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1178  
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1179  static struct notifier_block hyp_init_cpu_pm_nb = {
1fcf7ce0c Lorenzo Pieralisi 2013-08-05 @1180  	.notifier_call = hyp_init_cpu_pm_notifier,
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1181  };
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1182  
1fcf7ce0c Lorenzo Pieralisi 2013-08-05 @1183  static void __init hyp_cpu_pm_init(void)
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1184  {
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1185  	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1186  }
06a71a24b Sudeep Holla      2016-04-04 @1187  static void __init hyp_cpu_pm_exit(void)
06a71a24b Sudeep Holla      2016-04-04  1188  {
06a71a24b Sudeep Holla      2016-04-04  1189  	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
06a71a24b Sudeep Holla      2016-04-04  1190  }
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1191  #else
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1192  static inline void hyp_cpu_pm_init(void)
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1193  {
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1194  }
06a71a24b Sudeep Holla      2016-04-04  1195  static inline void hyp_cpu_pm_exit(void)
06a71a24b Sudeep Holla      2016-04-04  1196  {
06a71a24b Sudeep Holla      2016-04-04  1197  }
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1198  #endif
1fcf7ce0c Lorenzo Pieralisi 2013-08-05  1199  
1e947bad0 Marc Zyngier      2015-01-29 @1200  static void teardown_common_resources(void)
1e947bad0 Marc Zyngier      2015-01-29  1201  {
1e947bad0 Marc Zyngier      2015-01-29  1202  	free_percpu(kvm_host_cpu_state);
1e947bad0 Marc Zyngier      2015-01-29  1203  }
1e947bad0 Marc Zyngier      2015-01-29  1204  
1e947bad0 Marc Zyngier      2015-01-29 @1205  static int init_common_resources(void)
1e947bad0 Marc Zyngier      2015-01-29  1206  {
1e947bad0 Marc Zyngier      2015-01-29  1207  	kvm_host_cpu_state = alloc_percpu(kvm_cpu_context_t);
1e947bad0 Marc Zyngier      2015-01-29  1208  	if (!kvm_host_cpu_state) {

:::::: The code at line 1016 was first introduced by commit
:::::: 3401d54696f992edf036f00f46c8c399d1b75c2a KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl

:::::: TO: Christoffer Dall <c.dall@virtualopensystems.com>
:::::: CC: Marc Zyngier <marc.zyngier@arm.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/9DWx/yDrRhgMJTb
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
6xJHOAhm2oCCbcEreMXDaxbGptdHOM/l1tNu3dtsxbSYEGa0tHTc3m4fwKVpXfaM2FKlM+cu
DsKihN/Bvr20iLwSPtfc4lvHtQaZvpBM28s17squhYGzP6GInPn2SDi+PUhILgujSrCtRnaS
0I4i0ThkO2DOfV3CR04goMt661l4s2JHgnQaakwucFcrOrlPspV/nMEBe4z9p2M2hISdhce0
jSu9YroCppkWgmmfq/WJ9ju7FV9p9/OsUePsFu057qf0ium0iO7YrGUga5/c1lBu3Xmz8eQA
zUlDcRuHGSyuHPc9OEFJHaIAaXKsBEbObn1XjsvnwPmzafYx09LJlMI2VDSlfMr73qd86s5O
aEAyU6mAZZmYzbmeT7hPxq234GaIu0KpUjoLpu3s5AJmXzFLKLkn6uyMp6IyFeSnbN1GZVgb
juMH8h81L6QDqLQcqS7/KIUIYqjZbZ6bY2J72NRMPh8p52LlyZIrTw52u24tWI7b/sq1J0aF
M8IH3F/w+JrH9bzAybJQIzLXYjTDTQN1G6+Yztj4zHCfk2cV16Tlpoqs5wdGnV7MzA5xu+EW
i4WK5XMjoMTjoy0QDW9DZk2tKeXsxuJO+SHgOoOctezGBlMZP78xk/NB/52l9vIBjzifjTZ8
h59tCzNV8tt3fGgrV9sb98hecWUkr/p3L+q7Su7IhKAH5JhrD+ksd04oBV/HZ17B2nGP+LcT
BAkC4Jec70abhNeCBHJ6CPlyyCUKltKp9X1cb+o3yFarl6TlzY/3wSTcdDShfd8+PFy+Xd5e
vl/eyYFFGKdyte7itjlCng1tLIh42hDhMFLrTz7ff3v5CmayHp++Pr3ffwMNRJknMwNyjvNx
uvC7T7ehSCYP5zM0ecogmTXWh5C/yR5N/nawjqv8TR7bDhcYEscnAXBZN0C4UGOJ/vn06+PT
2+UBDhZniteuPZoNBZh516B2mqJvJu5f7x/kN54fLv+FCMniXf2mJV0vp0YSq/zKv3SCzcfz
+++XH08kvU3gkfjy9/IaX0f8+vH28uPh5fUiGyzcrViNauFPTaG4vP/n5e0PJb2P/7u8/c9N
+v318qgKJ9gSrTbepP+RPX39/d3+ir6oAT3lzN0siIMuwmDd/FYiRJsGgL/Wf03VK2vy32DU
7fL29eNGdRboTKnAeUvWxLGOBpYmEJjAhgKBGUUC1GvOCCJ9i/ry4+UbnND9tEm4zYY0Cbdx
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
AyNtDusdJgMA

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--/9DWx/yDrRhgMJTb--
