Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECCAC433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 07:34:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE6942071B
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 07:34:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjjuAgDI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE6942071B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DE14B14E;
	Thu,  3 Sep 2020 03:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 07WWkdXuatRS; Thu,  3 Sep 2020 03:34:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6DA4B0F9;
	Thu,  3 Sep 2020 03:34:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE824B0D9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 03:34:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBISzZjdv-41 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 03:34:11 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC614B0AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 03:34:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599118451;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7m+3y8HZpdkKrL2fKJDo0dr5pGtpONuJ0q4X9ebwmUY=;
 b=NjjuAgDINjSzlY43pxhM5vZ7xQzDRxOe2hF1lim9Rs+pfOI0MxdlbjAiZVxd5L+T6+mOXz
 kHUa6FYj1BEppfeyGvChHN0Z/SiXDuGxX6WuF41cM4xX9cUj2MbUiH8dWQ4wySrGGEHMZb
 0I70umWVcaIQ8OTCi35tCdVBo+wUPRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-02GfyovUP5uECm96YlIOGA-1; Thu, 03 Sep 2020 03:34:09 -0400
X-MC-Unique: 02GfyovUP5uECm96YlIOGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC821019625;
 Thu,  3 Sep 2020 07:34:07 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 196715C1C2;
 Thu,  3 Sep 2020 07:34:04 +0000 (UTC)
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
Date: Thu, 3 Sep 2020 17:34:02 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-1-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> Hello folks,
> 
> This is version three of the KVM page-table rework that I previously posted
> here:
> 
>    v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
>    v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
> 
> Changes since v2 include:
> 
>    * Rebased onto -rc2, which includes the conflicting OOM blocking fixes
>    * Dropped the patch trying to "fix" the memcache in kvm_phys_addr_ioremap()
> 

It's really nice work, making the code unified/simplified greatly.
However, it seems it doesn't work well with HugeTLBfs. Please refer
to the following test result and see if you have quick idea, or I
can debug it a bit :)

Note: I think the failing cases (FAIL[1] and FAIL[2]) would be
caused by same issue.

Machine	     Host                     Guest              Result
===============================================================
ThunderX2    VA_BITS:   42           PAGE_SIZE:  4KB     Passed
              PAGE_SIZE: 64KB                    64KB     passed
              THP:       disabled
              HugeTLB:   disabled
---------------------------------------------------------------
ThunderX2    VA_BITS:   42           PAGE_SIZE:  4KB     Passed
              PAGE_SIZE: 64KB                    64KB     passed
              THP:       enabled
              HugeTLB:   disabled
----------------------------------------------------------------
ThunderX2    VA_BITS:   42           PAGE_SIZE:  4KB     Fail[1]
              PAGE_SIZE: 64KB                    64KB     Fail[1]
              THP:       disabled
              HugeTLB:   enabled
---------------------------------------------------------------
ThunderX2    VA_BITS:   39           PAGE_SIZE:  4KB     Passed
              PAGE_SIZE: 4KB                     64KB     Passed
              THP:       disabled
              HugeTLB:   disabled
---------------------------------------------------------------
ThunderX2    VA_BITS:   39           PAGE_SIZE:  4KB     Passed
              PAGE_SIZE: 4KB                     64KB     Passed
              THP:       enabled
              HugeTLB:   disabled
--------------------------------------------------------------
ThunderX2    VA_BITS:   39           PAGE_SIZE: 4KB     Fail[2]
              PAGE_SIZE: 4KB                    64KB     Fail[2]
              THP:       disabled
              HugeTLB:   enabled

NOTE: The commands used to start VM are same for FAIL[1] and
FAIL[2] and the host kernel log are similar. So I don't provide
the kernel log for FAIL[2]. I guess they're caused by same
issue.

Fail[1]
===============================================================

start_vm_aarch64_hugetlbfs() {
    echo 16 > /sys/kernel/mm/hugepages/hugepages-524288kB/nr_hugepages

    /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64                     \
    --enable-kvm -machine virt,gic-version=host                                 \
    -cpu host -smp 8,sockets=8,cores=1,threads=1                                \
    -m 4G -mem-prealloc -mem-path /dev/hugepages                                \
    -monitor none -serial mon:stdio -nographic -s                               \
    -bios /home/gavin/sandbox/qemu.main/pc-bios/edk2-aarch64-code.fd            \
    -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image               \
    -initrd /home/gavin/sandbox/images/rootfs.cpio.xz                           \
    -append "earlycon=pl011,mmio,0x9000000"                                     \
    -device virtio-net-pci,netdev=unet,mac=52:54:00:f1:26:a6                    \
    -netdev user,id=unet,hostfwd=tcp::50959-:22                                 \
    -drive file=/home/gavin/sandbox/images/vm.img,if=none,format=raw,id=nvme0   \
    -device nvme,drive=nvme0,serial=foo                                         \
    -drive file=/home/gavin/sandbox/images/vm1.img,if=none,format=raw,id=nvme1  \
    -device nvme,drive=nvme1,serial=foo1
}

[  160.889802] Unable to handle kernel paging request at virtual address 003fffff7fc00034
[  160.897712] Mem abort info:
[  160.900507]   ESR = 0x96000004
[  160.903550]   EC = 0x25: DABT (current EL), IL = 32 bits
[  160.908848]   SET = 0, FnV = 0
[  160.911896]   EA = 0, S1PTW = 0
[  160.915024] Data abort info:
[  160.917891]   ISV = 0, ISS = 0x00000004
[  160.921722]   CM = 0, WnR = 0
[  160.924678] [003fffff7fc00034] address between user and kernel address ranges
[  160.931808] Internal error: Oops: 96000004 [#1] SMP
[  160.936676] Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun bridge stp llc rfkill ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib vfat fat ib_umad rpcrdma sunrpc rdma_ucm ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi ipmi_ssif qedr ib_uverbs crct10dif_ce i2c_smbus ghash_ce sha2_ce sha256_arm64 ib_core sha1_ce ipmi_devintf ipmi_msghandler thunderx2_pmu ip_tables xfs libcrc32c sg ast i2c_algo_bit drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_ttm_helper qede ttm mpt3sas qed drm raid_class e1000e scsi_transport_sas crc8 gpio_xlp i2c_xlp9xx dm_mirror dm_region_hash dm_log dm_mod
[  161.007565] CPU: 222 PID: 4559 Comm: qemu-system-aar Not tainted 5.9.0-rc3-gavin+ #4
[  161.015293] Hardware name: Default string MT91-FS1/MT91-FS1, BIOS 28m 12/14/2019
[  161.022676] pstate: 60400009 (nZCv daif +PAN -UAO BTYPE=--)
[  161.028250] pc : __free_pages+0x24/0x60
[  161.032074] lr : free_pages.part.102+0x2c/0x38
[  161.036504] sp : fffffe0031b2f8a0
[  161.039805] x29: fffffe0031b2f8a0 x28: 0000000040000000
[  161.045104] x27: fffffe0031b2f9c8 x26: 0000000000000007
[  161.050402] x25: 0000000000000003 x24: fffffe0010f16000
[  161.055700] x23: 0000000020000000 x22: 0000000040000000
[  161.060998] x21: 0000000000000002 x20: 0000000060000000
[  161.066296] x19: fffffc0f1b050010 x18: 0000000000000000
[  161.071595] x17: 0000000000000000 x16: 0000000000000000
[  161.076893] x15: 0000000000000000 x14: 0000000000000000
[  161.082191] x13: 0000000000000000 x12: 0000000000000001
[  161.087489] x11: 0000000000000003 x10: 0000000000000002
[  161.092787] x9 : fffffe001035fca4 x8 : 0000000000000007
[  161.098085] x7 : 00000000fffffff3 x6 : fffffe0010126370
[  161.103383] x5 : fffffe0031b2f9e8 x4 : 0000040080000000
[  161.108681] x3 : 003fffff7fc00034 x2 : 00000000ffffffff
[  161.113979] x1 : 0000000000000000 x0 : 003fffff7fc00000
[  161.119277] Call trace:
[  161.121713]  __free_pages+0x24/0x60
[  161.125189]  free_pages.part.102+0x2c/0x38
[  161.129272]  free_pages+0x1c/0x28
[  161.132586]  stage2_map_walker+0xbc/0x218
[  161.136584]  __kvm_pgtable_walk+0xec/0x1c8
[  161.140667]  _kvm_pgtable_walk+0xa4/0xe0
[  161.144578]  kvm_pgtable_stage2_map+0xa4/0x118
[  161.149022]  kvm_handle_guest_abort+0x48c/0xa08
[  161.153543]  handle_exit+0x134/0x198
[  161.157107]  kvm_arch_vcpu_ioctl_run+0x4f0/0x880
[  161.161721]  kvm_vcpu_ioctl+0x3a8/0x808
[  161.165546]  __arm64_sys_ioctl+0x1dc/0xcf8
[  161.169642]  do_el0_svc+0xf4/0x1b8
[  161.173039]  el0_sync_handler+0xf8/0x124
[  161.176949]  el0_sync+0x140/0x180
[  161.180254] Code: d503201f 9100d003 52800022 4b0203e2 (b8e20064)
[  161.186408] ---[ end trace d0b1b117875f8fcd ]---
[  161.191012] Kernel panic - not syncing: Fatal exception
[  161.196247] SMP: stopping secondary CPUs
[  161.200206] Kernel Offset: 0xc0000 from 0xfffffe0010000000
[  161.205677] PHYS_OFFSET: 0x80000000
[  161.209154] CPU features: 0x0046002,22800c38
[  161.213410] Memory Limit: none
[  161.216474] ---[ end Kernel panic - not syncing: Fatal exception ]---


FAIL[2]
================================================================
start_vm_aarch64_hugetlbfs() {
    echo 4096 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

    /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64                     \
    --enable-kvm -machine virt,gic-version=host                                 \
    -cpu host -smp 8,sockets=8,cores=1,threads=1                                \
    -m 4G -mem-prealloc -mem-path /dev/hugepages                                \
    -monitor none -serial mon:stdio -nographic -s                               \
    -bios /home/gavin/sandbox/qemu.main/pc-bios/edk2-aarch64-code.fd            \
    -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image               \
    -initrd /home/gavin/sandbox/images/rootfs.cpio.xz                           \
    -append "earlycon=pl011,mmio,0x9000000"                                     \
    -device virtio-net-pci,netdev=unet,mac=52:54:00:f1:26:a6                    \
    -netdev user,id=unet,hostfwd=tcp::50959-:22                                 \
    -drive file=/home/gavin/sandbox/images/vm.img,if=none,format=raw,id=nvme0   \
    -device nvme,drive=nvme0,serial=foo                                         \
    -drive file=/home/gavin/sandbox/images/vm1.img,if=none,format=raw,id=nvme1  \
    -device nvme,drive=nvme1,serial=foo1
}

[  666.278391] Unable to handle kernel paging request at virtual address 03fffffefde00034
[  666.286304] Mem abort info:
[  666.289086]   ESR = 0x96000004
[  666.292142]   EC = 0x25: DABT (current EL), IL = 32 bits
[  666.297440]   SET = 0, FnV = 0
[  666.300481]   EA = 0, S1PTW = 0
[  666.303616] Data abort info:
[  666.306484]   ISV = 0, ISS = 0x00000004
[  666.310306]   CM = 0, WnR = 0
[  666.313269] [03fffffefde00034] address between user and kernel address ranges
[  666.320393] Internal error: Oops: 96000004 [#1] SMP
[  666.325259] Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun bridge stp llc rfkill ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib ib_umad vfat fat rpcrdma sunrpc rdma_ucm ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi qedr ib_uverbs ipmi_ssif ib_core crct10dif_ce i2c_smbus ghash_ce sha2_ce sha256_arm64 sha1_ce ipmi_devintf ipmi_msghandler thunderx2_pmu ip_tables xfs libcrc32c sg ast i2c_algo_bit drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_ttm_helper qede ttm qed mpt3sas drm e1000e raid_class crc8 scsi_transport_sas gpio_xlp i2c_xlp9xx dm_mirror dm_region_hash dm_log dm_mod
[  666.396150] CPU: 168 PID: 42112 Comm: qemu-system-aar Not tainted 5.9.0-rc3-gavin+ #5
[  666.403965] Hardware name: Default string MT91-FS1/MT91-FS1, BIOS 28m 12/14/2019
[  666.411348] pstate: 60400009 (nZCv daif +PAN -UAO BTYPE=--)
[  666.416922] pc : __free_pages+0x24/0x60
[  666.420746] lr : free_pages.part.102+0x2c/0x38
[  666.425176] sp : ffffffc024a23840
[  666.428477] x29: ffffffc024a23840 x28: 0000000040000000
[  666.433776] x27: ffffffc024a239c8 x26: 0000000000000007
[  666.439074] x25: 0000000000000003 x24: ffffffc010ec0000
[  666.444373] x23: 0000000000200000 x22: 0000000040200000
[  666.449671] x21: 0000000040000000 x20: ffffff8f34576000
[  666.454969] x19: 0000000000000002 x18: 0000000000000000
[  666.460267] x17: 0000000000000000 x16: 0000000000000000
[  666.465565] x15: 0000000000000000 x14: 0000000000000000
[  666.470863] x13: 0000000000000000 x12: 0000000000000001
[  666.476161] x11: 0000000000000003 x10: 0000000000000002
[  666.481459] x9 : ffffffc0103522f4 x8 : 0000000000000007
[  666.486757] x7 : ffffffc0249960f8 x6 : ffffffc0101162f8
[  666.492055] x5 : ffffffc024a239e8 x4 : 0000000000000004
[  666.497353] x3 : 03fffffefde00034 x2 : 00000000ffffffff
[  666.502651] x1 : 0000000000000000 x0 : 03fffffefde00000
[  666.507950] Call trace:
[  666.510385]  __free_pages+0x24/0x60
[  666.513861]  free_pages.part.102+0x2c/0x38
[  666.517945]  free_pages+0x1c/0x28
[  666.521260]  stage2_map_walker+0xb0/0x208
[  666.525257]  __kvm_pgtable_walk+0xe0/0x1b8
[  666.529340]  __kvm_pgtable_walk+0xb8/0x1b8
[  666.533424]  _kvm_pgtable_walk+0xa4/0xe0
[  666.537334]  kvm_pgtable_stage2_map+0xa0/0x118
[  666.541779]  kvm_handle_guest_abort+0x48c/0xa38
[  666.546300]  handle_exit+0x134/0x198
[  666.549864]  kvm_arch_vcpu_ioctl_run+0x4f0/0x880
[  666.554479]  kvm_vcpu_ioctl+0x3a8/0x808
[  666.558304]  __arm64_sys_ioctl+0x1dc/0xcf8
[  666.562402]  do_el0_svc+0xf4/0x1b8
[  666.565799]  el0_sync_handler+0xf8/0x124
[  666.569709]  el0_sync+0x140/0x180
[  666.573014] Code: d503201f 9100d003 52800022 4b0203e2 (b8e20064)
[  666.579197] ---[ end trace 52b60e2f408396b6 ]---
[  666.583801] Kernel panic - not syncing: Fatal exception
[  666.589035] SMP: stopping secondary CPUs
[  666.592996] Kernel Offset: 0xb0000 from 0xffffffc010000000
[  666.598467] PHYS_OFFSET: 0x80000000
[  666.601944] CPU features: 0x0046002,22800c38
[  666.606200] Memory Limit: none
[  666.609264] ---[ end Kernel panic - not syncing: Fatal exception ]---

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
