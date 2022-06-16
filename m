Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEEDC43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 17:49:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D3340B75;
	Thu, 16 Jun 2022 13:49:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aLIzyjNnDlUD; Thu, 16 Jun 2022 13:49:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B0040C0A;
	Thu, 16 Jun 2022 13:49:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 517C340B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:49:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e8ioVrSO6m1p for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 13:49:00 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B90E40D0B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:49:00 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id z14so1925074pgh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eyrQYf3qGX/bwiZJZi/KY4gBIl7LqIwQjm23sBtKPrI=;
 b=dLj4xMG8sH329cgAbMfX4tibz1/aNHpDlse/GHLUZfNcXPLPRGaNdSjtQGH6XLAtTn
 Ct0ZQKG3l37BsMUtZkPSDHNI3+2Vk3Ixly2mEUb0UpdFYPjqpeoVQGF8rGet48bT2R8e
 OR82CUXov9HZTHEV4200fNxbwUi78GqRgEPz3V4QHjGNOX5mazUDeefs2574lLOR2Emz
 mlG/b64g/oFI0vl0EzVJ3tsVWF+JQJmVjWZm7JNx42Uz5yFgqvx+RoAXmOneLrqE4qE8
 rdJM2RCXUkV5CJXRlk2Z3PWyhcfdjFWGm2x9C1BaSsdRb4/2JIsiey+tcfhJjxfvRlcF
 gdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eyrQYf3qGX/bwiZJZi/KY4gBIl7LqIwQjm23sBtKPrI=;
 b=O5OKBtzFNnbpNQqZN6B72QfbPC4pUcOHta5UiNJtAg5NUcLg47C7YG+Lb2VxXBTekf
 UzpKUx+Z+3CueM9RnhCBPn1otgF1V5KAmUkioxRfCLqAPS4p/dhXNRWDjgCtjxB4kcAh
 Sv/uhsRO06ugIzT5xf71U5uZn3+/WmMMnDbCmXKRx3DlYiFye1pio637eyaFBAbmQ95x
 +2rvTlbQ7JkTsfTKAksZ+G60Ql22sdgqUzlcV3p3VLxTNnGDTpQD5XfzWoZOFwpVdbaa
 EqPtuMJDWn3j4ElbYCEj8tVZVb+AtY78Lj/Rbat0Ck5TNekRK2fHqH9wuH2mePmUrgCM
 Kn9w==
X-Gm-Message-State: AJIora/u9l43U0xMBKcv9cYjG4EpYbiqNWN7b9Nrb5nmm03WEN8nJZBv
 YPtSA6OMu5ksCxyUcuIHV3rpfg==
X-Google-Smtp-Source: AGRyM1tkw3+ELT9V5Q3czRrAJteD0bdQXUGqzn4c0pF68MYM1bzAZEGqbvy2QHXqYw0iPw+VpC07HQ==
X-Received: by 2002:a65:6499:0:b0:3fc:dcaa:ad62 with SMTP id
 e25-20020a656499000000b003fcdcaaad62mr5533019pgv.63.1655401739091; 
 Thu, 16 Jun 2022 10:48:59 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 jh7-20020a170903328700b0015e8d4eb2a8sm1904414plb.242.2022.06.16.10.48.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 10:48:58 -0700 (PDT)
Date: Thu, 16 Jun 2022 17:48:54 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 1/5] KVM: Shove vm stats_id init into kvm_create_vm()
Message-ID: <YqttBirNDDwHLR2V@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-2-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-2-oupton@google.com>
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 maz@kernel.org
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

On Wed, May 18, 2022, Oliver Upton wrote:
> Initialize the field alongside the other struct kvm fields. No
> functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6d971fb1b08d..36dc9271d039 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1101,6 +1101,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	 */
>  	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
>  
> +	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
> +			"kvm-%d", task_pid_nr(current));

After looking at the next patch, can you opportunistically tweak this to (a) have
the string on the first line, and (b) align indentation?  I.e.

	snprintf(kvm->stats_id, sizeof(kvm->stats_id), "kvm-%d",
		 task_pid_nr(current));

That makes it a lot easier to see what the string will look like.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
