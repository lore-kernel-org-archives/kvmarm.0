Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B90CC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 15:39:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4C334B18F;
	Wed, 12 Jan 2022 10:39:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hMpnVIrLL8Qj; Wed, 12 Jan 2022 10:39:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE77D4B1FD;
	Wed, 12 Jan 2022 10:39:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 555624B1E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:39:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1om7TyYMw5qQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 10:39:10 -0500 (EST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45CEA4B18F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:39:10 -0500 (EST)
Received: by mail-lf1-f48.google.com with SMTP id x22so9444926lfd.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 07:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4NHrrtVx/ROy3kyTlu3CE7Qr8R3mDdPRYahp1mG4kmY=;
 b=B3rgZ7TabV4LX9H6WnaYZZEmZ5pe9BI/soLu1GNchfDygG0BfByZZvt+R8JxgpSNny
 taj0E2QyqpUkIF3Nvnc+JJ+Oo/fhg0ptG4xvr4dQuzCDNhR2CTSV8fZcZB7iDbzSQ5FM
 WUlFpW8SgMvEtUmmJDtwJw5ERPVoY/mWvAeCemQTWpDRCZBrA4hdLwzlpHjjs8jzdEPu
 cLYG3C/4hEdnX2FvVl3StblDUOcZsMegX2fGX7kUcXdV7yHdfEjvq2XdwUHx6wtvgjZm
 V9Fl1mUK7AydBSYK0Tm9hKornS7+YwUU2eSVI1pRjkVy04JacmwPWXs6VGW4keCmYe9N
 ZfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4NHrrtVx/ROy3kyTlu3CE7Qr8R3mDdPRYahp1mG4kmY=;
 b=D/e7345aN7WHL2wmutYEFQVBLXzioPxh/saYubD1T6SjMc0ngsKOYlFgAFvw8SqvkT
 qiwNq6/t96QQ4gMtG6IGrGMiaW4nGGLt097ItVUQ/f6u4lwx/mvbtSBn02mnCRx4YJ4L
 nvIGdFi8yXIupz7mDyNB4l3BUGyFmrJXLA6Cpqo+R0wuQ308LGEqogPMJpQbKvYx195l
 ru9Izxxt9ttdILmC+y/GMG9H9NfWiHgaNF5Gg/JtjKbGTMCslGRHKxEzQVQAUhYsDiSz
 MMsSPE6N+ZT5AHMIbQowCv250JNlsu4fy7JmXsZug525IvWv9Xwx+jdxLpYVRXK1mh8s
 NS/w==
X-Gm-Message-State: AOAM530610QvVOms08JhJrY88zsjoE4R7w99UhkMqSpNxoegzXH2DbG2
 mAlClcS/dZVX+xxgf28PgNJkkdJHNncmV/ar3//7HA==
X-Google-Smtp-Source: ABdhPJyZcAf6iXBV+8nq0HU9ppkAPT2/aEbylm9rx5FMjJZsnQSALWFPMZ6r3jb0Q7/zqxxt8c25XqedkVk6grCm3Uo=
X-Received: by 2002:a05:651c:334:: with SMTP id
 b20mr58189ljp.275.1642001948722; 
 Wed, 12 Jan 2022 07:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20220112152155.2600645-1-ricarkol@google.com>
In-Reply-To: <20220112152155.2600645-1-ricarkol@google.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 12 Jan 2022 09:38:57 -0600
Message-ID: <CAOQ_QshBSJTR2aH4nDNnXD9ZsmU0uE+7Bh_SUHOBZEpNWGnfUA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] arm64: debug: mark test_[bp, wp,
 ss] as noinline
To: Ricardo Koller <ricarkol@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, maz@kernel.org
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

On Wed, Jan 12, 2022 at 9:22 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Clang inlines some functions (like test_ss) which define global labels
> in inline assembly (e.g., ss_start). This results in:
>
>     arm/debug.c:382:15: error: invalid symbol redefinition
>             asm volatile("ss_start:\n"
>                          ^
>     <inline asm>:1:2: note: instantiated into assembly here
>             ss_start:
>             ^
>     1 error generated.
>
> Fix these functions by marking them as "noinline".
>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
