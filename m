Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB83C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:58:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D04661165
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D04661165
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12C9D4A19F;
	Mon, 27 Sep 2021 02:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DKS+dbdCdcfY; Mon, 27 Sep 2021 02:58:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1AD84A1B0;
	Mon, 27 Sep 2021 02:58:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC05749F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:58:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Edr5ceaK2wxQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 02:58:33 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF5CE49E57
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:58:32 -0400 (EDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6hxLf006952; 
 Mon, 27 Sep 2021 02:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2py7wAsJWXG4npGlcEaG4sxglSIfcxDBKt4Tx5S1/jw=;
 b=V8zmWhUJ9ZuPfoL4N+IoKp70cr/+MLOYS52QwMMT/IEJ5vbLkjXTso76yuKupXBC1ie4
 B50i12wiBr7PjIfMVTJKEcX3SvlLQIc+cBahp5VV8CP6YIgn3qdwnKz4WZYlHmoojP4y
 7Dt0LZieDIr8LU4ZnQdF0hZfauzzR4GYXtcggsDvU3KJTQ75EpdiTw3gL53tNSgXyIGD
 +bvRRxjOyg9Y0rcOB7TH34YwpGN/Kd3z5KPDQy3zL1Bip2UePGlptAeRHYIqVGGPAty4
 XQimhoo0zH7dZUBzBsxDBji7iPpd0c0kWBlLYvbs8R7Ooa9JxpHzr8bXW1CoobIhFN8b Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bagrycd3s-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 02:58:26 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R6rbTm001549;
 Mon, 27 Sep 2021 02:58:25 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.102])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bagrycd34-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 02:58:25 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
 by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R6vCRK030322;
 Mon, 27 Sep 2021 06:58:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
 (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
 by ppma06ams.nl.ibm.com with ESMTP id 3b9u1j1j6r-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 06:58:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
 [9.149.105.232])
 by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP
 id 18R6rKDu59769286
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 27 Sep 2021 06:53:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 9327952069;
 Mon, 27 Sep 2021 06:58:18 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown
 [9.171.4.236])
 by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 59E7552050;
 Mon, 27 Sep 2021 06:58:17 +0000 (GMT)
Subject: Re: [PATCH 05/14] KVM: s390: Clear valid_wakeup in
 kvm_s390_handle_wait(), not in arch hook
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-6-seanjc@google.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <daa2e1e4-7e64-fe2f-5bae-9ec8d7df2428@de.ibm.com>
Date: Mon, 27 Sep 2021 08:58:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925005528.1145584-6-seanjc@google.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sdW3Ij9mEecI7Aw6Z8BoXZNDLsey3ObW
X-Proofpoint-GUID: PjUGObNwPsXJ0I6DdoYvd1PayuaV3MlM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_01,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> Move the clearing of valid_wakeup out of kvm_arch_vcpu_block_finish() so
> that a future patch can drop said arch hook.  Unlike the other blocking-
> related arch hooks (vcpu_blocking/unblocking()), vcpu_block_finish() needs
> to be called even if the KVM doesn't actually block the vCPU.  This will
> allow future patches to differentiate between truly blocking the vCPU and
> emulating a halt condition without introducing a contradiction.
> 
> Alternatively, the hook could be renamed to kvm_arch_vcpu_halt_finish(),
> but there's literally one call site in s390, and future cleanup can also
> be done to handle valid_wakeup fully within kvm_s390_handle_wait() and
> allow generic KVM to drop vcpu_valid_wakeup().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/kvm/interrupt.c | 1 +
>   arch/s390/kvm/kvm-s390.c  | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 10722455fd02..520450a7956f 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1336,6 +1336,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
>   no_timer:
>   	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>   	kvm_vcpu_block(vcpu);
> +	vcpu->valid_wakeup = false;
>   	__unset_cpu_idle(vcpu);
>   	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>   
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7cabe6778b1b..08ed68639a21 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5082,7 +5082,7 @@ static inline unsigned long nonhyp_mask(int i)
>   
>   void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
>   {
> -	vcpu->valid_wakeup = false;
> +

maybe just remove the line instead of adding an empty one?

>   }
>   
>   static int __init kvm_s390_init(void)
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
