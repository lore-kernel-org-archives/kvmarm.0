Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4491AC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:59:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBA9F60F4B
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DBA9F60F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D92A4A19F;
	Mon, 27 Sep 2021 02:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8LXcBAXPyqPH; Mon, 27 Sep 2021 02:59:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26EC549F5D;
	Mon, 27 Sep 2021 02:59:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5AC49F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oM72Jdu0FtPp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 02:59:02 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A13649E57
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:59:02 -0400 (EDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R3PTcB020186; 
 Mon, 27 Sep 2021 02:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2JYJIDFlPwlrS54K2p3vPgGj+dRVbn4qYQyxYmTPv4g=;
 b=pEQAchES6fgvbAigrUBgoLW01Gn6fFbkCPWsrzI0VQrK+B1Jrf2z5XoqyuB/t4gFXlev
 Q/q1F5sQGby3W8Z3E0WO+9tgHp1ImtZD4aLqit3T79sbffcpGxMZeMWDFrFZcwhf+LkF
 K/eGPISZaprkvGqG1TYOO7pmC5FD0d/XCg2yzfMVjyZ9eomfgTz8F4IUTBbVCh75n6V2
 tp5x8WYTf69sw+0/LlD7B5vnSFHRSY4k1HvYbxlZ4bKUflP+qhKo1LRZwWquCtJcPWkn
 SnDknpH6wTCKGYkxiLbWl8IHzT6GB40VmYgVQfsZ+je/LF3aBhzyDFX/tHfSAEuwyz3k zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bahc5uvrb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 02:58:54 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R6jfCE003005;
 Mon, 27 Sep 2021 02:58:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bahc5uvqv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 02:58:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R6vMWI024280;
 Mon, 27 Sep 2021 06:58:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com
 (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
 by ppma04ams.nl.ibm.com with ESMTP id 3b9ud99feb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 06:58:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
 [9.149.105.232])
 by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 18R6wlBe64422230
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 27 Sep 2021 06:58:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 685F652052;
 Mon, 27 Sep 2021 06:58:47 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown
 [9.171.4.236])
 by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ACCCA5205A;
 Mon, 27 Sep 2021 06:58:45 +0000 (GMT)
Subject: Re: [PATCH 06/14] KVM: Drop obsolete kvm_arch_vcpu_block_finish()
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-7-seanjc@google.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <67f2fede-8f36-6052-44c9-ef5c6d28d143@de.ibm.com>
Date: Mon, 27 Sep 2021 08:58:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925005528.1145584-7-seanjc@google.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LSLDyPLJ69vM1eY9Fjr2eADaS5UHtBw3
X-Proofpoint-GUID: BYb0saIe7Tr6n1VpNl__d4G6AFmLjwTz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_02,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270042
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, David Matlack <dmatlack@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



Am 25.09.21 um 02:55 schrieb Sean Christopherson:
> Drop kvm_arch_vcpu_block_finish() now that all arch implementations are
> nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/arm64/include/asm/kvm_host.h   | 1 -
>   arch/mips/include/asm/kvm_host.h    | 1 -
>   arch/powerpc/include/asm/kvm_host.h | 1 -
>   arch/s390/include/asm/kvm_host.h    | 2 --
>   arch/s390/kvm/kvm-s390.c            | 5 -----
>   arch/x86/include/asm/kvm_host.h     | 2 --
>   virt/kvm/kvm_main.c                 | 1 -
>   7 files changed, 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..4e0ad0fff540 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -716,7 +716,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>   static inline void kvm_arch_hardware_unsetup(void) {}
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>   
>   void kvm_arm_init_debug(void);
>   void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 696f6b009377..72b90d45a46e 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -897,7 +897,6 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>   int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 59cb38b04ede..8a84448d77a6 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -864,6 +864,5 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_exit(void) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>   
>   #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..a22c9266ea05 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1010,6 +1010,4 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu);
> -
>   #endif
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 08ed68639a21..17fabb260c35 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5080,11 +5080,6 @@ static inline unsigned long nonhyp_mask(int i)
>   	return 0x0000ffffffffffffUL >> (nonhyp_fai << 4);
>   }
>   
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
>   static int __init kvm_s390_init(void)
>   {
>   	int i;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1e0e909b98b2..4e8c21083bdb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1916,8 +1916,6 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
>   }
>   
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> -
>   static inline int kvm_cpu_get_apicid(int mps_cpu)
>   {
>   #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2ba22b68af3b..2015a1f532ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3301,7 +3301,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   	}
>   
>   	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> -	kvm_arch_vcpu_block_finish(vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_vcpu_block);
>   
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
