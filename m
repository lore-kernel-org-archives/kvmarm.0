Return-Path: <SRS0=KNE3=OI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF1BC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 18 Sep 2021 16:17:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4CC261100
	for <kvmarm@archiver.kernel.org>; Sat, 18 Sep 2021 16:17:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D4CC261100
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C32340C88;
	Sat, 18 Sep 2021 12:17:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v9UMv6SO8wIv; Sat, 18 Sep 2021 12:17:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A2A4A00B;
	Sat, 18 Sep 2021 12:17:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B04FB49E5F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Sep 2021 12:17:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LM0ULT2Ab8nB for <kvmarm@lists.cs.columbia.edu>;
 Sat, 18 Sep 2021 12:17:52 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06F0C40C88
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Sep 2021 12:17:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
 Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=72laBgllLDvPPa2HfsaMPLygXh5K0JehqshRy10whlY=; b=ZTkaeV2R+oaPcuuO5Pm/NzZiPl
 wxPGSGhljHUAHbjxgWz04hQIljJMoZzyNNSn0XLtWKp8AFrP7o0+5p0JeLoAEyL/2sSFmE9V3WuNR
 3whi7jZZ09yrvQNHhzmAR0EwqVLUWe58qL2l+12TsdfXeKIQiwwIa9yNWuQKsfwopR+5miv1fFZIu
 CeJXfaPzGp6OqCCkAK1QgdqIeVQyOhMw+WaUQqmVrDob1FT6j8sUjfhq7Zmrx9IvkEEQbYO9EXAUI
 yjayHJyEitoKoLlPQaEh+HS0N3x2U4rCfFJuRcSvuPE8yyAartBF9Phg+Ih8A8S7hDzP3RLj+Yxb0
 y0JBZyNQ==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54638)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1mRd2D-0000Nl-Gb; Sat, 18 Sep 2021 17:17:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1mRd29-0000Wl-UH; Sat, 18 Sep 2021 17:17:45 +0100
Date: Sat, 18 Sep 2021 17:17:45 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

This morning, I upgraded my VM host from Debian Buster to Debian
Bullseye. This host (Armada 8040) runs libvirt. I placed all the VMs
into managedsave, which basically means their state is saved out by
QEMU ready to be resumed once the upgrade is complete.

Initially, I was running 5.11 on the host, which didn't have POSIX
ACLs enabled on tmpfs. Sadly, upgrading to Bullseye now requires
this to be enabled, so I upgraded the kernel to 5.13 to avoid this
problem - without POSIX ACLs on tmpfs, qemu refuses to even start.

Under Bullseye with 5.13, I could start new VMs, but I could not
resume the saved VMs - it would spit out:

2021-09-18T11:14:14.456227Z qemu-system-aarch64: Invalid value 236 expecting positive value <= 162
2021-09-18T11:14:14.456269Z qemu-system-aarch64: Failed to load cpu:cpreg_vmstate_array_len
2021-09-18T11:14:14.456279Z qemu-system-aarch64: error while loading state for instance 0x0 of device 'cpu'
2021-09-18T11:14:14.456887Z qemu-system-aarch64: load of migration failed: Invalid argument

Essentially, what this is complaining about is that the register
list returned by the KVM_GET_REG_LIST ioctl has reduced in size,
meaning that the saved VM has more registers that need to be set
(236 of them, after QEMU's filtering) than those which are actually
available under 5.13 (162 after QEMU's filtering).

After much debugging, and writing a program to create a VM and CPU,
and retrieve the register list etc, I have finally tracked down
exactly what is going on...

Under 5.13, KVM believes there is no PMU, so it doesn't advertise the
PMU registers, despite the hardware having a PMU and the kernel
having support.

kvm_arm_support_pmu_v3() determines whether the PMU_V3 feature is
available or not.

Under 5.11, this was determined via:

	perf_num_counters() > 0

which in turn was derived from (essentially):

	__oprofile_cpu_pmu && __oprofile_cpu_pmu->num_events > 0

__oprofile_cpu_pmu can be set at any time when the PMU has been
initialised, and due to initialisation ordering, it appears to happen
much later in the kernel boot.

However, under 5.13, oprofile has been removed, and this test is no
longer present. Instead, kvm attempts to determine the availability
of PMUv3 when it initialises, and fails to because the PMU has not
yet been initialised. If there is no PMU at the point KVM initialises,
then KVM will never advertise a PMU.

This change of behaviour is what breaks KVM on Armada 8040, causing
a userspace regression.

What makes this more confusing is the PMU errors have gone:

5.13:
[    0.170514] PCI: CLS 0 bytes, default 64
[    0.171085] kvm [1]: IPA Size Limit: 44 bits
[    0.172532] kvm [1]: vgic interrupt IRQ9
[    0.172650] kvm: pmu event creation failed -2
[    0.172688] kvm [1]: Hyp mode initialized successfully
...
[    1.479833] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 7 counters available

5.11:
[    0.138831] PCI: CLS 0 bytes, default 64
[    0.139245] hw perfevents: unable to count PMU IRQs
[    0.139251] hw perfevents: /ap806/config-space@f0000000/pmu: failed to register PMU devices!
[    0.139503] kvm [1]: IPA Size Limit: 44 bits
[    0.140735] kvm [1]: vgic interrupt IRQ9
[    0.140836] kvm [1]: Hyp mode initialized successfully
...
[    1.447789] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 7 counters available

Overall, what this means is that the only way to safely upgrade from
5.11 to 5.13 (I don't know where 5.12 fits in this) is to completely
shut down all your VMs. You can't even migrate them to another
identical machine across these kernels. You have to completely shut
them down.

I did manage to eventually rescue my VMs after many hours, by booting
back into 5.11, and then screwing around with bind mounts to replace
/dev with a filesystem that did have POSIX ACLs enabled, so libvirt
and qemu could then resume the VMs and cleanly shut them down all
down.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
