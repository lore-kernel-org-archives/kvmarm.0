Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BD0C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 16:48:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E84426128A
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 16:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E84426128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5EC4B0D6;
	Tue, 28 Sep 2021 12:48:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QoAGhA-oenqG; Tue, 28 Sep 2021 12:48:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3179549F5F;
	Tue, 28 Sep 2021 12:48:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11A8D4048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 12:48:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4nsGQ92VIhO4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 12:48:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E447B402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 12:48:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632847710;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QtwllydMHGyFzLESHuCUqc8VrgYc5TwZXFenjH66G5Q=;
 b=dODjxfgIK/c0Z2e8snbS3Ok1XftjQFHtZazoQAmdtpw/sFN3gbwWadmq9ici6JvFIMY/hl
 c94vERqdpG+0fdLwrCXksXTwNAiqWTXoS27teztbf21+LwLBHVtHT/088jRNP+pGnzunmZ
 AhyipHsdaQ2I8SKKimwsFzuQhyyrIDY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-Iev6xzpuOiaCCpILeZMYtQ-1; Tue, 28 Sep 2021 12:48:29 -0400
X-MC-Unique: Iev6xzpuOiaCCpILeZMYtQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 j26-20020a508a9a000000b003da84aaa5c5so3458142edj.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 09:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=QtwllydMHGyFzLESHuCUqc8VrgYc5TwZXFenjH66G5Q=;
 b=VU4rSxYQekOo8Tg3eJ0LERQSW5JNtCKi1ghq86S7LJj+QD9efbCpN4W9NVcJRsyBR2
 mXVuqXQRVsFMnmQRXxaidHAeaoX/O0zZBj0FXYB8ZWOVMec9m4z78HCeR1sfx9jEqB6Q
 CKzGwCHQCZ3o1yh2w7G3JFQRDZnTIV/5Lt7YE6X/QW4obg07auUlB3DyszCu1y6Mjqi7
 n05ohFthqksDt5oqGL6eZcFKn4G7YEnwVEiwp2HcB6CgKlRTc9RdaTwPls4F4Q4q2ZR5
 JzAEFlEeUeNzM9Cf9pvjnAz/xY77KUc7nol97CFxGBcUge3sXK4wq97TbM48ObRKBBz7
 uNkA==
X-Gm-Message-State: AOAM533qRbaA0sVNnV2r8egUtHh7dPzqvc0BKX0u84crEiNQsjGeIUtA
 BUnEF8oOPrOCWFfSyqIEotVoMAkPmTn4Uqeu1isS6iF4itMX41FQ/iRV5rzRi9TyzyVNj3tu/bp
 Gl5XuIKk+ydpwQw4EWuifEw0h
X-Received: by 2002:a17:906:a018:: with SMTP id
 p24mr7690003ejy.349.1632847707975; 
 Tue, 28 Sep 2021 09:48:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5WRomeP223sMlhPYW+g/nZ1wzj0FfwwqeLtK6g6ahSepfC1HmQoBasRiPn6KMGx6W7tiHdg==
X-Received: by 2002:a17:906:a018:: with SMTP id
 p24mr7689966ejy.349.1632847707766; 
 Tue, 28 Sep 2021 09:48:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id w26sm5644114edu.59.2021.09.28.09.48.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Sep 2021 09:48:27 -0700 (PDT)
Message-ID: <c69d7f93-131a-0848-c197-fa7ab26f812d@redhat.com>
Date: Tue, 28 Sep 2021 18:48:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 4/6] kvm: use kvfree() in kvm_arch_free_vm()
To: Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-5-jgross@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210903130808.30142-5-jgross@suse.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, ehabkost@redhat.com,
 Will Deacon <will@kernel.org>, maz@kernel.org, Joerg Roedel <joro@8bytes.org>,
 "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Jim Mattson <jmattson@google.com>
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

On 03/09/21 15:08, Juergen Gross wrote:
> By switching from kfree() to kvfree() in kvm_arch_free_vm() Arm64 can
> use the common variant. This can be accomplished by adding another
> macro __KVM_HAVE_ARCH_VM_FREE, which will be used only by x86 for now.
> 
> Further simplification can be achieved by adding __kvm_arch_free_vm()
> doing the common part.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Queued this one already, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
