Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF17C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 22:34:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0EAE4A531;
	Thu,  9 Dec 2021 17:34:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2IZe5b1kSknT; Thu,  9 Dec 2021 17:34:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F954B09C;
	Thu,  9 Dec 2021 17:34:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 637474AC78
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 17:34:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9XksFazm9DWJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 17:34:46 -0500 (EST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
 [209.85.208.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0189D49FB7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 17:34:45 -0500 (EST)
Received: by mail-ed1-f46.google.com with SMTP id l25so24497280eda.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 14:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=e0xWu4FRBdpcPopR+tYuIVQgtChl7uURnH22cFlaA5A=;
 b=fXFqrXO6Mqxbn1VMEeZUPYqwDn0Axi1WQoRKyIm0Wko3qi8To1yhBnzyQBnuuJpvU9
 tR9dyu+xSqUrDMvvahFuENMdiHPMXRJ4o4DKWl7ljy3Mz+Nrt/S+gISbeuWgkR+cEOle
 5HfXVZsTYOn1456X/asYJBDh/+KY3upkcOeEjnBkupzBDml+tuhSKMfrF3aI5eR2H+9m
 AxeYoRDcvdBsZd0n9yd/Xbwhp7Eyc1p3mbosWQ4yNA3IyW8kf/9iawYPt5tkAmOak1+/
 fGSMnJ7WfE0c7M44ExGyn8D0Cv6BJ1MqLcK9O6mLpBWThWXCeEb72RJR4HaLNOYG3YT4
 QWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=e0xWu4FRBdpcPopR+tYuIVQgtChl7uURnH22cFlaA5A=;
 b=QG7fDakNL1p8XYCSqpnxAAMPY3ZuRu7d3dMl4fDNfzW9kM2cb+7Tn7FQbuDF72bhvF
 CeSlrJXpvsuvmJi8GbgXNwjgHALanCRtxdPYM/zRnmxUyqA7v1xmdzDvkR8jzSB7mdD/
 Uy4iiq3vn1Ns2FfZamdkn+tekFyFpxrRg7n4cMFCt5DSNjSQMKDUKH56ARcuM21+ioa1
 wshL54gxyB4/Ir0GYOEafqQWwSlhmIiqZqxN5ALImfvxOxWNdbESwG1nDQqozRKOT9dP
 rVtQ7VeFGahKd926IJ3mnoRuLLC8nkbtCgK83V4pUc61Q7RBapOpE3yoW/M3wv9bHluk
 2gfQ==
X-Gm-Message-State: AOAM533BdX7iuAkrjHmM88SOhdYT1mbLIjsUYKLZDKYJmYeFx5RhI14k
 E2g7mx76OPPtQnY8ZxMlSc0=
X-Google-Smtp-Source: ABdhPJyxMeAJrbZymRVBb0iPORoJGZau5fLIvkWo7GHCG5UbZ3oj1yMvqn13BjVbdYGJRifVkBRRAw==
X-Received: by 2002:a17:906:b2c7:: with SMTP id
 cf7mr19483296ejb.303.1639089285134; 
 Thu, 09 Dec 2021 14:34:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id go10sm459347ejc.115.2021.12.09.14.34.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 14:34:44 -0800 (PST)
Message-ID: <6cb2cd57-16f3-d0ec-adf6-cb8fdcbae035@redhat.com>
Date: Thu, 9 Dec 2021 23:34:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 08/12] KVM: Reinstate gfn_to_pfn_cache with
 invalidation support
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-9-dwmw2@infradead.org>
 <b1bacc6f-be56-4108-6e52-4315a021184b@redhat.com>
 <b614d9ae0fe7910cfa72eee0b4077776f8012e5f.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b614d9ae0fe7910cfa72eee0b4077776f8012e5f.camel@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On 12/9/21 21:40, David Woodhouse wrote:
> 
> NP, very useful fixes. Thanks. Incremental patch looks like this. It
> passes the xen_shinfo_test self-test; will test it with real Xen guests
> tomorrow and repost based on your kvm/next tree once it shows up.

Compared to the review it's missing this hunk:


@@ -265,7 +265,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
   
   	gpc->valid = false;
   
-	old_khva = gpc->khva;
+	old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
   	old_dirty = gpc->dirty;
   	old_gpa = gpc->gpa;
   	old_pfn = gpc->pfn;

Otherwise looks good, thanks!

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
