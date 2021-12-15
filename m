Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAC1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 13:09:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C17C14B15E;
	Wed, 15 Dec 2021 08:09:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpUuehUXUsIL; Wed, 15 Dec 2021 08:09:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D744B159;
	Wed, 15 Dec 2021 08:09:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C938A4B159
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:09:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KXPenQq08RZ8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 08:09:32 -0500 (EST)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E12264B156
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:09:32 -0500 (EST)
Received: by mail-io1-f47.google.com with SMTP id z18so29974243iof.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 05:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=o4iIShwRZXVs+Jqe3sjEL4qca2b6WBA7S1kQI8tQZtI=;
 b=YtPWBvOOukfpvhAJj/xlXfYe8gUBwnx8340HV/ecPejIFL3fKlsIoOnR0af5pSq7xP
 uYBx9sDiDfMX7GhmzKnez0oE+TrU1OrbESwb2i1d0zhGpBLq2cVSCxwWNGrPGcPx08KK
 IHDRff46Ut75ToL5XSc2IknpJwHetqXnPS3YmSeihIiGU+ourObiTDUfXX1/pXQSg7zi
 aZ+JBWfeWFHfPSm06flG4XgdvPr4Hu4i/pkSmPDCzq8q5iDu6o0K6nI5cOYJpAv50L+W
 KT9sz2A/VM7a0QM2zYopHRbLHjoEY/hx/3rQUpiw+5uS1cfVSAbcjUFxZuonSjRQ+7RT
 AH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=o4iIShwRZXVs+Jqe3sjEL4qca2b6WBA7S1kQI8tQZtI=;
 b=lkJppnLb/sd2lm4fGWuAquIfk4zjwO4sZQWz8v7fdJnamh9QHCF9ElM7l9A48dof5t
 ep6esGfCrvs5RXqyq7IT2fnJh8lKBX7ldwunru7TT/cmxqKCYpnEycJJF1IcBTmjyMmL
 RwBVBmsP2/0/CEbdF/J+9JOD94iBQEzcv6aaYe57VS6lHsXVLVWJ51j/XhnlAGmmSwaw
 68vYE5ydmekum71phtVxNMslB+xwNrXwyRT2nwP9LVIrbepr4rEf49uUWljEfOzsK5mA
 HBIKzcaA1CeIdl4oUFQe37Q2Iy/BSSvoVWlHyGt/XKmTew/TOShdEcAcAKUU4sF8+u44
 BP9g==
X-Gm-Message-State: AOAM533LZE+WgBy504uBqVDQ7ILrcsQx2qOs4wFvbhqviwyJOvNvbHXQ
 FWq4qIqsqSZQ04ebyqLK5QzCEw==
X-Google-Smtp-Source: ABdhPJxHP9shiYlKk4jWXLjv34HJNRfwkTsv5D61mMoKrRdSXUIyH2G+QT3+Yuji/sEszZxl2Bdq1g==
X-Received: by 2002:a05:6638:2503:: with SMTP id
 v3mr5510689jat.397.1639573772084; 
 Wed, 15 Dec 2021 05:09:32 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id t6sm1088516iov.39.2021.12.15.05.09.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Dec 2021 05:09:31 -0800 (PST)
Date: Wed, 15 Dec 2021 13:09:28 +0000
From: Oliver Upton <oupton@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1
 as undefined
Message-ID: <YbnpCFBPNgmkEXjf@google.com>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-2-oupton@google.com>
 <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Hi Mark,

On Wed, Dec 15, 2021 at 11:39:58AM +0000, Mark Rutland wrote:
> Hi Oliver,
> 
> On Tue, Dec 14, 2021 at 05:28:07PM +0000, Oliver Upton wrote:
> > Any valid implementation of the architecture should generate an
> > undefined exception for writes to a read-only register, such as
> > OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> > behavior.
> > 
> > Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> > write ever traps to EL2, inject an undef into the guest and print a
> > warning.
> 
> I think this can still be read amibguously, since we don't explicitly state
> that writes to OSLSR_EL1 should never trap (and the implications of being
> UNDEFINED are subtle). How about:
> 
> | Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to EL2, but
> | the KVM trap handler for OSLSR_EL1 handlees writes via ignore_write(). This
> | is confusing to readers of the code, but shouldn't have any functional impact.
> |
> | For clarity, use write_to_read_only() rather than ignore_write(). If a trap
> | is unexpectedly taken to EL2 in violation of the architecture, this will
> | WARN_ONCE() and inject an undef into the guest.

Agreed, I like your suggested changelog better :-)

> With that:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
