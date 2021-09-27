Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB0CC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 07:42:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4886860F4F
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 07:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4886860F4F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB32640667;
	Mon, 27 Sep 2021 03:42:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UlQQkKq8gtyY; Mon, 27 Sep 2021 03:42:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 957DF4086C;
	Mon, 27 Sep 2021 03:42:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7364086C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 03:42:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id twMVoKB8FHoR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 03:42:18 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FB3B40667
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 03:42:18 -0400 (EDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6N7M9005443; 
 Mon, 27 Sep 2021 03:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YFLMT0ds8B51YoPeiTDVIVA6vGyULsGli9Aks3m+P7c=;
 b=B/MtyVfQ4WIDN/zzCURgLgVrDgYib3Zxuyo3GM51rYg4xea0OrbdqC20W/C3T5yhHdik
 ceZWphfcImGMdWodNAemYg+uqjW8VgPX6QxGAbi/iTQ7Il8dsgqFkU4B/sB2GHtu9+mC
 gmVd/NTskUxt4s+CmKOUTJCsHu10xqbY/vWFhiowMFaQhPHgbA6GPEtk1bXdHi8vI1A5
 5pNqHgCcI9D/ZiJbVJ542nwsbSC6segvfrJ7cTu9I/fzcRLlU4LzkBBMQeQE2RWoOeId
 S11eDvHJw66OsiUrDvQ2nFzerS3aKjYxhdHPxcdWl8bSJYmyMurXnWfD2ihm9LznFnVL AA== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4n4mp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 03:42:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R7LfeI006890;
 Mon, 27 Sep 2021 03:42:07 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com
 [149.81.74.106])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4n4kw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 03:42:07 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
 by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R7bGK0031905;
 Mon, 27 Sep 2021 07:42:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by ppma04fra.de.ibm.com with ESMTP id 3b9ud9h2gs-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 07:42:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
 [9.149.105.232])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 18R7g13h45547826
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 27 Sep 2021 07:42:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 065D85204E;
 Mon, 27 Sep 2021 07:42:01 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown
 [9.171.4.236])
 by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AAB4D5204F;
 Mon, 27 Sep 2021 07:41:59 +0000 (GMT)
Subject: Re: [PATCH 10/14] KVM: Split out a kvm_vcpu_block() helper from
 kvm_vcpu_halt()
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-11-seanjc@google.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <16f057a7-5603-d4b1-266c-f9564b564f32@de.ibm.com>
Date: Mon, 27 Sep 2021 09:41:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925005528.1145584-11-seanjc@google.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fnFVhWWVIL3Czmll3D06Tgte64FqxA88
X-Proofpoint-ORIG-GUID: VjiGuiDIF0Z96qvd11e4c35K5QcdL-IE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_02,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270051
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
> Factor out the "block" part of kvm_vcpu_halt() so that x86 can emulate
> non-halt wait/sleep/block conditions that should not be subjected to
> halt-polling.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++------------
>   2 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2a8be3fb9ba..655c2b24db2d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -966,6 +966,7 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>   void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>   
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 280cf1dca7db..fe34457530c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3199,6 +3199,34 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +/*
> + * Block the vCPU until the vCPU is runnable, an event arrives, or a signal is
> + * pending.  This is mostly used when halting a vCPU, but may also be used
> + * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
> + */
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +{
> +	bool waited = false;
> +
> +	kvm_arch_vcpu_blocking(vcpu);
> +
> +	prepare_to_rcuwait(&vcpu->wait);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		if (kvm_vcpu_check_block(vcpu) < 0)
> +			break;
> +
> +		waited = true;
> +		schedule();
> +	}
> +	finish_rcuwait(&vcpu->wait);
> +
> +	kvm_arch_vcpu_unblocking(vcpu);
> +
> +	return waited;
> +}
> +
>   static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   					  ktime_t end, bool success)
>   {
> @@ -3221,6 +3249,12 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   	}
>   }
>   
> +/*
> + * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
> + * polling is enabled, busy wait for a short time before blocking to avoid the
> + * expensive block+unblock sequence if a wake event arrives soon after the vCPU
> + * is halted.
> + */
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> @@ -3245,21 +3279,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   		} while (kvm_vcpu_can_poll(cur, stop));
>   	}
>   
> -	kvm_arch_vcpu_blocking(vcpu);
> -
> -	prepare_to_rcuwait(&vcpu->wait);
> -	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
> -		if (kvm_vcpu_check_block(vcpu) < 0)
> -			break;
> -
> -		waited = true;
> -		schedule();
> -	}
> -	finish_rcuwait(&vcpu->wait);
> -
> -	kvm_arch_vcpu_unblocking(vcpu);
> +	waited = kvm_vcpu_block(vcpu);
>   
>   	cur = ktime_get();
>   	if (waited) {
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
