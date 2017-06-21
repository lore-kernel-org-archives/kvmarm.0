From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Wed, 21 Jun 2017 18:59:58 +0800
Message-ID: <3a02e425-5782-dad4-efda-fdc5df73dcf7@huawei.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com> <594A4205.70201@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8F540296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 06:55:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YDJlEvSqTdvn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jun 2017 06:55:48 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66EE540190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 06:55:46 -0400 (EDT)
In-Reply-To: <594A4205.70201@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Huangshaoyu <huangshaoyu@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/6/21 17:53, James Morse wrote:
> I think we discussed this before[0], your CPU has a feature called 'hwpoison'
> that is uses to support RAS. Linux also has a feature called 'hwpoison' [1][2],
> which handles the offline-ing of memory pages when it receives a notification
> through APEI. I've tried to call this memory_failure() to avoid this confusion.
> 
> This patch is to handle stage2 faults when the page was removed from the stage2
> mapping by the memory_failure() code. v3 of this patch[3] does a much better job
> of describing this.
> 
> (... I don't think your question is related to this patch ...)

I know your meaning about the Linux 'hwpoison' feature.
Let see the code that how to get the "pfn"

///get the pfn
fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
gfn = fault_ipa >> PAGE_SHIFT;
pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);


As shown in above code, when happen SEA, the fault_ipa is got from the HPFAR_EL2 register.
if the HPFAR_EL2 does not record the IPA. the fault_ipa is zero, then gfn is zero, so the pfn is unknown.

so below judgement always false although firmware notify the memory_failure through APEI, because we do not get the right fault memory page.
using this API "kvm_vcpu_get_fault_ipa" can not get the right fault memory page if cpu does not update the HPFAR_EL2.

+	if (pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(hva, vma);
+		return 0;
+	}

so may be you need to double confirm that whether armv8.0/armv8.2  standard CPU can always update the  HPFAR_EL2 registers.
