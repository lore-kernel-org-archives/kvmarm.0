Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED453468C1C
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785352467; cv=none; b=sSiZpFNn587LaTVH6ApQKUd6z8Tml4mKundI50xwhP1KVdfoqAsaCX1MghflSwhwurnK9VPMSQcH93iofoHcChevZ3W4KEXzmXyz64pRoRIybzfmDVoRgc7ekjSfPTB2KclMA2V/kJD60rYOBmNgkPSXjUv4v1WTUYqXpyqtcjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785352467; c=relaxed/simple;
	bh=p+KQBr3YBqi1Te9/qMRupI2bpcRUQjWYqgBXzXRGFJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hr6cReaT3Gjdv0sqxLuAX57ovMSZMYxOvtMPl5tg08seMZJTuchsKCVsS/hD2lIu7FpbzuebOgDemN7qyGSNJ+coMKKhBEhf7Vzw6iLU+p6PtTujrJaML8cMFxfQNOVp7ietlPTL5pfMQrqeUDdws1oVpzAZgUbJz2yMilrnYUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gu+KqKTs; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gu+KqKTs"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc640dfde3so15390355ad.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785352465; x=1785957265; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k+h3h28T4F1i6amtJLbBYljCpqUwi0VZ2BDIbc8sgVg=;
        b=gu+KqKTs3zSFZb0flUoQ8rdAfELkxgNfdTqHyN7Yx6FpPPD6xOvwK+AIoHeFg0jDdS
         NtLGEAThn896T7PFlyCQ8uWDWYheEiiQwKmc8LYaMEey3WX8zTZ0P7gC7rf2W9IAWqeW
         +U0w0yV63K91KZMNLskfN5yT3nmu3WEjKUrjSar687kB0haDErLLOKy2ctutJytqKVBE
         EyWn528ezyq3I1GyAWFypxqJ0xwB8Pp6XZ2G0Sp7HeLrzuSi3z6UyelHD/g/mLs1Upxa
         pYGY1Hl5xAG8GpH5Y8zFi/cHrKk/T8k7cxByuNMaSolvCAUGY4xNKGfol1pTXVytlkoE
         F2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785352465; x=1785957265;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k+h3h28T4F1i6amtJLbBYljCpqUwi0VZ2BDIbc8sgVg=;
        b=eZcGDYyZQZgPoxqYCytC6hZzEakMzoVFbbcHBleiEvJjjeL2M5y7HLRLDIvcZ2gsvV
         /R9DCsh+dvgMea/hltY67KlPx7J/vgzkNJP7HysM1zU1INXWI+IGOAkHfG6RdQanv192
         y2tN7CIgg8hPz4iM4TUew4Rux7BlqiBtF8kMmSWNExgSj/XZWfHPCzlRDYCoyOlb8aAC
         uX9NP+cP9OAiwv419e5vlW7A23TxulLHX0xz29EUFTAOfX0pQ1BOJ48XmAdWzNDHzYAT
         QLUc5dIUzeFPohcG/5vifQLpmMdYZT+20UEsCLV8UmVFCM79boqwsjXagy8+iHqz3CCu
         AaBQ==
X-Forwarded-Encrypted: i=1; AHgh+RqHVfwmbzGpeVoySxeR9dOiAEuGnio8noDaMbrfDkNctW1aZBeC5uRf+sysL31hOmJq3dOfZGA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxagRVt+KcihoGJ7+L04p209+1nh6JNuFX6GY9Q72UFtGONGrk2
	Hl/g9Oqv+avMvARqjwS4iBfT5K+EtSSXTRBc84V6c1T4SY+FaKgwQzSyYsc02/XCp1aZTAngCji
	3RpNpMw==
X-Received: from pgae5.prod.google.com ([2002:a63:3705:0:b0:cb2:54cf:afe5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3204:b0:3c6:5673:2bd1
 with SMTP id adf61e73a8af0-3c8ba5da101mr8929380637.42.1785352465072; Wed, 29
 Jul 2026 12:14:25 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:14:24 -0700
In-Reply-To: <20260331194202.1722082-7-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-7-vipinsh@google.com>
Message-ID: <ampREGtEqKh8_-Ua@google.com>
Subject: Re: [PATCH v4 6/9] KVM: selftests: Add various print flags to KVM
 selftest runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev, 
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 31, 2026, Vipin Sharma wrote:
> @@ -27,10 +34,14 @@ class TestRunner:
>          return test
>  
>      def _log_result(self, test_result):
> -        logger.info("*** stdout ***\n" + test_result.stdout)
> -        logger.info("*** stderr ***\n" + test_result.stderr)
> -        logger.log(test_result.status,
> -                   f"[{test_result.status.name}] {test_result.test_path}")
> +        print_level = self.print_stds.get(test_result.status, "full")
> +
> +        if (print_level == "full" or print_level == "stdout"):
> +            logger.info("*** stdout ***\n" + test_result.stdout)

IMO, when the print_level is exactly stdout or stderr, the runner shouldn't spit
out the "*** std{out,err} ***" line, as it's pure noise.  E.g.

        print("\033[2K", end="\r", flush=True)
        if (print_level == "full"):
            logger.info("*** stdout ***\n" + test_result.stdout)
            logger.info("*** stderr ***\n" + test_result.stderr)
        elif (print_level == "stdout"):
            logger.info(test_result.stdout)
        elif (print_level == "stderr"):
            logger.info(test_result.stderr)

> +        if (print_level == "full" or print_level == "stderr"):
> +            logger.info("*** stderr ***\n" + test_result.stderr)
> +        if (print_level != "off"):
> +            logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
>  
>      def start(self):
>          ret = 0
> -- 
> 2.53.0.1118.gaef5881109-goog
> 
