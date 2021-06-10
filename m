Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF942C47094
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 16:42:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38736613E9
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 16:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38736613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F46C4A500;
	Thu, 10 Jun 2021 12:42:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vlpLfDpNPuGf; Thu, 10 Jun 2021 12:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEEA149F83;
	Thu, 10 Jun 2021 12:42:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74431407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 12:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7PYh4R5hyEHF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 12:42:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6F8401A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 12:42:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623343333;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=FTYsk+3ZrtMDgibB9knYQRxYmGEpuIUf1VdElxSCW6k=;
 b=JZtwbgDmHT/FTNTZJCcT8RvVUwUvL1ch/XoOfaTT5YSWlnoR8brWPAePJ78jjfnpek3A1E
 Wybf4xrnxK4hwoxiyrrgQxWv2NhVPNWtLbA09vFtYsoS6zUVIfe6Ff3R8qzZQL5T4AL2j8
 CTtREtQcBcHgn5jznOl47kYzrJ9HnWM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-TqI4Af90NuuLGXA3gfyHIw-1; Thu, 10 Jun 2021 12:42:10 -0400
X-MC-Unique: TqI4Af90NuuLGXA3gfyHIw-1
Received: by mail-wr1-f69.google.com with SMTP id
 e11-20020a056000178bb0290119c11bd29eso1243810wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 09:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=FTYsk+3ZrtMDgibB9knYQRxYmGEpuIUf1VdElxSCW6k=;
 b=ajQj0AIIpf42Ays5cujF6coyX3xnb78oEB6eznsPI4O+3aW026jFBnm5rvugRTasvu
 79EL1isJGDUvMCFy05U2AYK8vpcuNAFlDykIwXitCslzBOz9r0QRqziMBav/H1atJ/vI
 F6sbEvstC1xpq7Oc04h6fNQCu4t1ovu6qqZo43kfEQ9qxLSyVhjJ0Wbz5NsPpeUw0e5j
 M6IH8Q7AomAcLeqd2+dnG33y8SfvTU1SML7VBw0YLPaaBHi6QjLmJk1bCoRM17qdPv+z
 gYF5DInTe8uBVJ/rWT/oFMAIWC5N8pj2XyLn7MRCuHRKZjOi71SMRIclyPay0JBouoXm
 YMiw==
X-Gm-Message-State: AOAM531w8o2dmZlScNrjkfOVZG91utJh6bjEhEyGxiNgOpSO8/oCKRn7
 NqJ914cRAWfpr8i8laQgeKGN+VPsrjJvUq+f8iAtIle9rTzVCghDUE4iC4rvGTquoVMZGbzX+Wh
 yKPbqKWDknSvQJTMJr84UmVpF
X-Received: by 2002:adf:ab49:: with SMTP id r9mr6556044wrc.237.1623343329075; 
 Thu, 10 Jun 2021 09:42:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwT8GKTcc6CtIM2Omfzfm3HSpY3IDEVA0VZ0HkqF8YvTQlmVrTL+SEqxKoSDnFCTA+GbV+zog==
X-Received: by 2002:adf:ab49:: with SMTP id r9mr6556002wrc.237.1623343328880; 
 Thu, 10 Jun 2021 09:42:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a?
 ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
 by smtp.gmail.com with ESMTPSA id f13sm4050941wrt.86.2021.06.10.09.42.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 10 Jun 2021 09:42:08 -0700 (PDT)
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 2/4] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <345170fd-636c-f1be-7dc3-69467e51d872@redhat.com>
Date: Thu, 10 Jun 2021 18:42:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603211426.790093-3-jingzhangos@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 03/06/21 23:14, Jing Zhang wrote:
> +struct _kvm_stats_header {
> +	__u32 name_size;
> +	__u32 count;
> +	__u32 desc_offset;
> +	__u32 data_offset;
> +};
> +

Keeping this struct in sync with kvm_stats_header is a bit messy.  If 
you move the id at the end of the header, however, you can use the same 
trick with the zero-sized array that you used for _kvm_stats_desc.

> +struct kvm_vm_stats_data {
> +	unsigned long value[0];
> +};
> +

I posted the patch to switch the VM statistics to 64-bit; you can rebase 
on top of it.

> +#define KVM_GET_STATS_FD  _IOR(KVMIO,  0xcc, struct kvm_stats_header)

This should be _IO(KVMIO, 0xcc) since it does not have an argument.

> +#define STATS_DESC(stat, type, unit, scale, exp)			       \
> +	{								       \
> +		{							       \
> +			.flags = type | unit | scale,			       \
> +			.exponent = exp,				       \
> +			.size = 1					       \
> +		},							       \
> +		.name = stat,						       \

Here you can use

	type | BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |
	unit | BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |
	scale | BUILD_BUG_ON_ZERO(scale & ~KVM_STATS_SCALE_MASK) |

to get a little bit of type checking.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
