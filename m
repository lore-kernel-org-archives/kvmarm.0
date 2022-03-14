Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB1AC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 12:36:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04F65410FF;
	Mon, 14 Mar 2022 08:36:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BJDzhsthMqVN; Mon, 14 Mar 2022 08:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB3A49EF5;
	Mon, 14 Mar 2022 08:36:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC62349F0A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 08:36:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xL4PcJbzulZp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 08:36:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B987410FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 08:36:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647261399;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eudqKm2Y3v7ew9A9Kj5EXaC5PmAFpLSNV7O0yJqcVgU=;
 b=HCftuRQ9XwA1+SSO700Qo6HLHlVh+C7zGSrWzPtCcxCTQmI71Wefw5T8ygNw0Cdu0hZZ4I
 5N5etL1fdpDX5eD/snK/BJxqsNtMqqbiO9XkZS4to5L7knewW5ubUjI7mfp+vcOto3Zufq
 xLOCbqqdsm0QXf2AiHmKXra87s3+ZX0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-5qpMdyTRN3K6PrPFuALN6Q-1; Mon, 14 Mar 2022 08:36:38 -0400
X-MC-Unique: 5qpMdyTRN3K6PrPFuALN6Q-1
Received: by mail-wm1-f69.google.com with SMTP id
 o21-20020a05600c511500b003818c4b98b5so5677006wms.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 05:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eudqKm2Y3v7ew9A9Kj5EXaC5PmAFpLSNV7O0yJqcVgU=;
 b=HdYewbIs4U7VdrA/zhEKszTnrVyfFIfNe4bxmrEOlXF+qhz6U/eHuy/Czap8OpJQWA
 eDQeYwy/aqGwborVJAYcqNJg13b3Yh1rBD7tvYZycJf29TrqE0YguyxsKSMfFfMfy5SE
 Uzro1Gg/hQ41Rk4/rM2otyXdA5PER3r9E4T3vNP81A907IELTS4IWycd5tmEA8TUrFE1
 hkrfrurmPbhgpheiLjZ8Ihf4bEVQFexJ2sTmkspIM2QkQY0LPAgizNSNEiXnifVt/TgT
 7Pa2xmKAfBSLvmOaRQzae3FCKWDzXkTt1b8kzOMtXETLSjkE1j649iCzDgpnQIt/5TLD
 RTqQ==
X-Gm-Message-State: AOAM533hl/lL7R02aOF/bW9WrBrmJU+pzpuIHjexF80xXO/QsfpxecOd
 8+ozI/d43Q4uhS5HGt+hOy1z+6+SZ2GdZnxWi+uVv5TufvyP1HyWldQYVDEkzE71/a5IZ0iEDhK
 x8rfSUfoU+gjUL6l6HHiAlaPB
X-Received: by 2002:a7b:c922:0:b0:383:e7e2:4a1a with SMTP id
 h2-20020a7bc922000000b00383e7e24a1amr17333955wml.51.1647261396840; 
 Mon, 14 Mar 2022 05:36:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3s9jCPtybq2regT3D5KjzyZFBWX/SRJSkBKui5JV8DKw/fbF4fnMqLfFLWMHS7YPNfozrOw==
X-Received: by 2002:a7b:c922:0:b0:383:e7e2:4a1a with SMTP id
 h2-20020a7bc922000000b00383e7e24a1amr17333925wml.51.1647261396481; 
 Mon, 14 Mar 2022 05:36:36 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 u14-20020adfed4e000000b001e3323611e5sm12943506wro.26.2022.03.14.05.36.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 05:36:35 -0700 (PDT)
Date: Mon, 14 Mar 2022 13:36:33 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/3] configure changes and rename
 --target-efi
Message-ID: <20220314123633.67upt7a2qkjvhh3w@gator>
References: <20220223125537.41529-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20220223125537.41529-1-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, varad.gautam@suse.com,
 pbonzini@redhat.com, zixuanwang@google.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Feb 23, 2022 at 12:55:34PM +0000, Alexandru Elisei wrote:
> The first two patches are fixes for stuff I found while working on patch
> #3.
> 
> Patch #3 ("Rename --target-efi to --[enable|disable]-efi") is where the
> configure option --target-efi gets renamed.
> 
> Changes in v2:
> 
> * Dropped what was patch #3, which made arm/arm64 configure option
>   --target available to all architectures.
> 
> * Renamed --target-efi to --[enable|disable]-efi instead of --efi-payload.
> 
> Alexandru Elisei (3):
>   configure: Fix whitespaces for the --gen-se-header help text
>   configure: Restrict --target-efi to x86_64
>   Rename --target-efi to --[enable|disable]-efi
> 
>  Makefile             | 10 +++-------
>  configure            | 22 +++++++++++++++-------
>  lib/x86/acpi.c       |  4 ++--
>  lib/x86/amd_sev.h    |  4 ++--
>  lib/x86/asm/page.h   |  8 ++++----
>  lib/x86/asm/setup.h  |  4 ++--
>  lib/x86/setup.c      |  4 ++--
>  lib/x86/vm.c         | 12 ++++++------
>  scripts/runtime.bash |  4 ++--
>  x86/Makefile.common  |  6 +++---
>  x86/Makefile.x86_64  |  6 +++---
>  x86/access_test.c    |  2 +-
>  x86/efi/README.md    |  2 +-
>  x86/efi/run          |  2 +-
>  x86/run              |  4 ++--
>  15 files changed, 49 insertions(+), 45 deletions(-)
> 
> -- 
> 2.35.1
>

Applied to misc/queue and MR posted:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/26

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
