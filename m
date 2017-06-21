From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Wed, 21 Jun 2017 19:12:28 +0800
Message-ID: <3bcc724d-0aaf-3384-fc75-38c224f604ed@huawei.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com> <594A4205.70201@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67CBB40296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 07:08:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id itwi8jsslQBK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jun 2017 07:08:14 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69D5840190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 07:08:12 -0400 (EDT)
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

Hi james

On 2017/6/21 17:53, James Morse wrote:
> What happens if HPFAR_EL2 isn't set when this kind of error occurs?
> Provided EL3 can learn the physical address that triggered the exception then
> for firmware-first this isn't a problem. These errors should be taken to EL3 and
> then described by CPER records to the OS. The OS should process the CPER records
> in preference to attempting 'kernel first error handling'

here the pfn is from the HPFAR_EL2, not from the CPER record, which does not related with the CPER records.
Although OS can process the CPER records, but here the pfn may be always zero.
+	if (pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(hva, vma);
+		return 0;
+	}
