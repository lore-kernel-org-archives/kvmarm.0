Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477994D17B9;
	Mon, 28 Sep 2026 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603720; cv=none; b=Ly8mwPWeuDszBItOYbOn8r9+8YOVgt2odAKWpJx+W57STFf79CQ2i4GaZRyedaGW/+aR4QKmx2gd5rVCNm+CVWfd5xzmAk2awH9vmjJWtSjBrSaYtwfmsKNciJL83tvVajMW8t1Qn0Vcwh1+mP9abHusLV98sT+O9QDn7kMfFSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603720; c=relaxed/simple;
	bh=lgeeKqhHEm895kCw60vcS0c0qbxLWa1KXH5dC+xZ8o8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Z5gJzC7dJPWGLIeSXZVjJ84TMlYGPSEmLQ7gjKqzaRzuaK6cgKPfXc/XfVqPjJGuwMluvbii6fo7wvQLCP6ZbbSVWeoYMgNCrl+dYl2XTNnwnLaHTXonZ+B/ILFQuZBfIjDYgbsmAzTew6kvoHE9x+k+pwtyP1ygrz8FW6onN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RG9oNy0L; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RG9oNy0L"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3268B1C00;
	Mon, 28 Sep 2026 06:55:13 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 615A83F763;
	Mon, 28 Sep 2026 06:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790603716; bh=lgeeKqhHEm895kCw60vcS0c0qbxLWa1KXH5dC+xZ8o8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=RG9oNy0LPgTYLRgj8BSKPfl3R2ijszuaO5nA36mQiS+YKA5nXtyqzqZI2lPorQ4+9
	 1vp9yUr/Qn39ZN9AzUo9KCPbSvxgyi5OAIXa7MmF/pM0iIoUG4EfnZS6hnKZLBEIzP
	 nwsRygXMdeTncPucYonHNNnFZBQqZL2gWkIDK/aY=
Message-ID: <195cdfe4-a55a-453f-9c34-620738eca244@arm.com>
Date: Mon, 28 Sep 2026 14:55:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com> <arZmXFw5Jw2IbAmA@arm.com>
 <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com> <araketG70TIKeNuf@arm.com>
 <12e83d88-de4c-4230-aac2-1796123320ad@arm.com>
 <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
In-Reply-To: <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 28/09/2026 10:08, Suzuki K Poulose wrote:
> On 25/09/2026 18:50, Suzuki K Poulose wrote:
>> Hi Catalin
>>
>> On 25/09/2026 17:42, Catalin Marinas wrote:
>>> On Fri, Sep 25, 2026 at 04:02:24PM +0100, Suzuki K Poulose wrote:
>>>> On 25/09/2026 13:17, Catalin Marinas wrote:
>>>>> On Thu, Sep 24, 2026 at 02:51:59PM +0100, Suzuki K Poulose wrote:
>>>>>> From: Steven Price <steven.price@arm.com>
>>>>>>
>>>>>> Activate the RMM after the basic configuration. This is a memory
>>>>>> transferring stateful operation.
>>>>>>
>>
>> ...
>>
>>>>>> +
>>>>>> +    ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, 
>>>>>> SMC_RMI_RMM_ACTIVATE);
>>>>>> +    if (ret) {
>>>>>> +        pr_err("RMM activate failed (%d)\n", ret);
>>>>>> +        ret = ret < 0 ? ret : -ENXIO;
>>>>>> +    }
>>>>>> +
>>>>>> +    return ret;
>>>>>
>>>>> It was raised earlier this year [1] but I'm not sure it concluded. How
>>>>> do we handle kexec and kdump? I think RMI_RMM_DEACTIVATE only succeeds
>>>>> if nothing is delegated, so it would need all realms torn down 
>>>>> first. If
>>>>> that's not feasible, we could at least block (non-crash) kexec like 
>>>>> pKVM
>>>>> does.
>>>>
>>>> You are right, we can't DEACTIVATE until all granules have been
>>>> "undelegated" back. Not just the Realms, but also the GPTs/Tracking
>>>> Metadata etc would need to be reclaimed (when we get to support
>>>> dynamic GPT/Tracking metadata). For now, we should block the kexec.
>>>
>>> Looking more into this (and the memory hotplug story), I find it strange
>>> that simply having RME and a valid RMM imposes all these restrictions
>>> even if we never run or intend to run a realm. How common will
>>> RME-capable systems with RMM firmware be that are not used for CoCo? Or
>>> do we expect only CoCo systems to have capable/configured firmware (RME
>>> may be present in silicon anyway)?
>>
>> There is another angle to this :
>>
>> RMM may act as a TSM (as in the Trusted Security Manager in PCI TDISP)
>> context and provide setting up IDE connection between the RootPort/
>> EndPoint. So, the trigger point for the RMM activation would become 
>> the "First Delegate" request.
>>
>> Running an RMM just for the "TSM" functionality is not ideal.
>> In the absence of RMM, Linux can act as the baremetal TSM. But when the
>> RMM is present, we must use the RMM as the TSM, especially if the
>> Device will be assigned to a Realm.
>>
>> FEAT_RME capable systems don't need to enable RMM unless they want to
>> run CoCo guests.
>>
>>>
>>> Ideally we'd defer the RMM configuration and activation (and the
>>> tracking/GPT checks) until we first attempt to start a realm, keeping
>>> only the RMI_VERSION/FEATURES probing at boot. Not sure how feasible
>>> this is (memory is more fragmented by then for any contiguous donation).
>>> If we manage it, kexec and memory hotplug just work on hosts that never
>>> start a realm.
>>>
>>> The next best thing for kexec is to tear down the realms, undelegate
>>> the granules and deactivate the RMM before invoking kexec (with kdump
>>> that's harder as we likely no longer have a controlled shutdown).
>>
>> This is quite complicated, when we get the dynamic metadata support,
>> especially with the self-describing L1GPT and Tracking metadata.
>> But not impossible.
> 
> Looking at this again we could :
> 
> a. If the user triggers a graceful kexec reboot, i.e, without forced,
>     we should be able to deactivate the RMM. Since all processes are
>     killed, Realm VMs must be off and all granules reclaimed.
>     When we get to dynamic GPT/Tracking, we should additionally
>     reclaim them back.
> b. For forced reboot kexec, I don't think there is a safe way.
> 
> We have two options here :
> 
> 1. Disable kexec reboot (allowing kexec kdump) when the RMM is active
>     at kexec_load. I prefer this for now, and we could goto 2 eventually.
> 
> 2. Back out from machine_kexec() if the RMM was still active.
>     This allows (a) above.


I have the following patch (tested , but tf-RMM doesn't support 
DEACTIVATE yet), which correctly deactivates the RMM (well
at least tries).

---8>---


firmware: rmm: Deactivate RMM at reboot

Deactivate the RMM at system shutdown. This would allow a normal kexec 
to cleanup the state and boot into a new kernel gracefully.

Kdump kernels need not worry about an active RMM, as long as it can
handle the GPF on access to the Delegated granules.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
  arch/arm64/kernel/machine_kexec.c |  2 +
  drivers/firmware/arm_rmm/rmi.c    | 63 ++++++++++++++++++++++++++++++-
  include/linux/arm-rmi-cmds.h      | 10 +++++
  3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec.c 
b/arch/arm64/kernel/machine_kexec.c
index 8f9bc2327dc85..8f16f92a5d389 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -6,6 +6,7 @@
   * Copyright (C) Huawei Futurewei Technologies.
   */

+#include <linux/arm-rmi-cmds.h>
  #include <linux/interrupt.h>
  #include <linux/irq.h>
  #include <linux/kernel.h>
@@ -171,6 +172,7 @@ void machine_kexec(struct kimage *kimage)
  	BUG_ON(!in_kexec_crash && (stuck_cpus || (num_online_cpus() > 1)));
  	WARN(in_kexec_crash && (stuck_cpus || smp_crash_stop_failed()),
  		"Some CPUs may be stale, kdump will be unreliable.\n");
+	WARN(!in_kexec_crash && is_rmm_active(), "RMM is active, kexec will be 
unreliable.\n");

  	pr_info("Bye!\n");

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 51343e9d5c2a9..5b695f3155b1c 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -7,6 +7,7 @@
  #include <linux/memblock.h>
  #include <linux/memory.h>
  #include <linux/arm-rmi-cmds.h>
+#include <linux/reboot.h>
  #include <linux/slab.h>

  #include <asm/memory.h>
@@ -15,6 +16,13 @@
  /* RMM v2.0 defines RmiFeatureRegister0 to RmiFeatureRegister4. */
  static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
  static bool arm64_rmi_is_available;
+static bool arm64_rmm_active;
+
+bool is_rmm_active(void)
+{
+	return arm64_rmm_active;
+}
+EXPORT_SYMBOL_GPL(is_rmm_active);

  /**
   * rmi_granule_range_undelegate() - Undelegate a range of granules
@@ -1017,6 +1025,53 @@ bool is_rmi_available(void)
  }
  EXPORT_SYMBOL_GPL(is_rmi_available);

+static int rmi_rmm_deactivate(struct rmi_sro_state *sro)
+{
+	int ret;
+
+	if (!READ_ONCE(arm64_rmm_active))
+		return 0;
+
+	ret = WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, 
SMC_RMI_RMM_DEACTIVATE));
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(arm64_rmm_active, false);
+	WRITE_ONCE(arm64_rmi_is_available, false);
+
+	return ret;
+}
+
+static int rmi_reboot_notifier(struct notifier_block *nb,
+			       unsigned long action, void *data)
+{
+	int ret;
+
+	switch (action) {
+	case SYS_RESTART:
+	case SYS_HALT:
+	case SYS_POWER_OFF:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
+
+	if (!sro)
+		return -ENOMEM;
+
+	ret = rmi_rmm_deactivate(sro);
+	if (ret)
+		pr_emerg("RMM Deactivation failed: %d\n", ret);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rmi_reboot_nb = {
+	.notifier_call = rmi_reboot_notifier,
+};
+
  static int rmi_init_memory(void)
  {
  	int ret;
@@ -1025,7 +1080,10 @@ static int rmi_init_memory(void)
  	if (ret)
  		return ret;

-	return register_memory_notifier(&rmi_memory_nb);
+	ret = register_memory_notifier(&rmi_memory_nb);
+	if (ret)
+		return ret;
+	return register_reboot_notifier(&rmi_reboot_nb);
  }

  static int __init arm64_init_rmi(void)
@@ -1057,10 +1115,11 @@ static int __init arm64_init_rmi(void)
  		return ret;
  	}

+	WRITE_ONCE(arm64_rmm_active, true);
  	ret = rmi_init_memory();
  	if (ret) {
  		/* Deactivate the RMM */
-		WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
+		(void)rmi_rmm_deactivate(sro);
  		return ret;
  	}

diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 8fd90914c161a..5d31a4104ce72 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -88,6 +88,16 @@ long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
  	__ret;								\
  })

+
+#ifdef CONFIG_ARM_RMM_RMI
+bool is_rmm_active(void);
+#else
+static inline bool is_rmm_active(void)
+{
+	return false;
+}
+#endif	/* CONFIG_ARM_RMM_RMI */
+
  /**
   * rmi_rtt_data_map_init() - Create a mapping at protected IPA, 
copying contents
   *			     from a given non-secure source granule.
-- 
2.43.0


