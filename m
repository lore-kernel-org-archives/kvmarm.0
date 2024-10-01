Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B51B194AD1
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 23:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727824402; cv=none; b=piux/NEAIxVbXGk1Rv8h/x3meCQedBaEagsSsQNVR+A5HScrVEY+ac7vE+yJKt9Vexn3xeclFUSHYd/4zUoQIqcn0wVNQOGqRUICD4rVObosxPnc0pmjxUJIG8OenPFxvU1vJJmSPymPLxvJMBbojofD7pbrWlE7tdwNFhEwDf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727824402; c=relaxed/simple;
	bh=w++7hzLDS/8dZ/VoZ2hephh+rP/dNT8s02ewb/5KE7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TIgVLG8fsB4KtQ20Q9laRG16PIk4N7mw5bc+77SqXuMIt4x7DYOQ2Jf/zHi4tBxBpUkIQx5yPZyF0M2bkYMYLqb12KbLLiO/+XIgQB2V4htnGjI7OUQQy0Ng+58XyAGfiNZ93+qUt6uAOMEA86d1schaJdmzrwOxHZff7qzKwq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WOi74RDz; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WOi74RDz"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20b9b35c7c3so24605165ad.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Oct 2024 16:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1727824399; x=1728429199; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vF28sAx//tve6z0mOEzHepFQAlUB74FiXmJYm/deJzs=;
        b=WOi74RDzxa1Pv5o3q0pzqJ4EWmHk0nSTpar9sOH0c5HtFJbY+iGLE+Zh3PD0lOj3Jz
         aEKsA2VmCX4BllQTpCwRyjnEvP2cRU49pEqdVNKSK6o/HXZ4lSRi0i64V2IxL3Im+NMY
         wyYqsGaWu1I43GuQG3rM5iMzSK2lbZNvy5Eeyu6XRieW4nwP/Ub7uxzMUpJhy5O2guPa
         Vml93gx5BhQuKhba7z1pzVsoI97QvOYbN+hk8hgwdEZZAHRDn8AHtN1RgzWw0F8ETBQc
         U6xlf++WKVSzYMGQ8ZYI9+5zEv1m1JAii1OLL9ULEFq4V4VPVPcS0Z/V9eViibRneN8r
         NQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727824399; x=1728429199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vF28sAx//tve6z0mOEzHepFQAlUB74FiXmJYm/deJzs=;
        b=eUrNtQQUOJ1Ay/4CI+K+ZQlaa8ejwsx7oUO2UGH343OMwEp5Ep+a6z1JW5QiQJ6b/j
         lmIPoWojVXaEZ4dOe5DyavDi3elEvlfoeO11VgcXUt5QZH0K0nlssM/Vs0Usovad8m+D
         xQDgmJQZPUFZflWxpKea4UBZjjnu1xZrEFjRst8hgMBI+wpptuquuOo+uNo1PHOfck5f
         vzBixB5r49AWzbtJXIHWlv8k5mXFqon9dskT7Se3XtYN7zMqAu3msKxnmTjEis/2D9B0
         GqkkSwfdc98KiElRvO6mXcSEEbsg2DMQO10ZaJSzeys89e0TlbnFVns22N/wXs6z5Azr
         Bt7g==
X-Forwarded-Encrypted: i=1; AJvYcCV5OXhq5B1kPt716d4D6youfjfw2h7uaOseVJFuyWR9pve57hGuFXB+hBFHatUE2/AG494ZJdA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAz0Steg8qnVY8Wx1tl4LK9OwaZX6fQvTnP7cHOrk2w/hudE+J
	HhUqGm/lBGzj6gmzAC47883NgxYNMfr0qK+GIf5gtcTRAQtEE1rO/KQv3lIZ+Qk=
X-Google-Smtp-Source: AGHT+IEIrzHYfjGFMSAlwPPGGJUrbwH3BDEgMMmzhiHFcldc7QLYwSfdGVw09IGHWqEtu37pmMpU7g==
X-Received: by 2002:a17:903:41c4:b0:20b:a431:8f17 with SMTP id d9443c01a7336-20bc5a887b7mr17332045ad.58.1727824398654;
        Tue, 01 Oct 2024 16:13:18 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e37225sm74521465ad.197.2024.10.01.16.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 16:13:18 -0700 (PDT)
Date: Tue, 1 Oct 2024 16:13:15 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Kees Cook <kees@kernel.org>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Florian Weimer <fweimer@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>,
	Ross Burton <ross.burton@arm.com>,
	David Spickett <david.spickett@arm.com>,
	Yury Khrustalev <yury.khrustalev@arm.com>,
	Wilco Dijkstra <wilco.dijkstra@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v13 04/40] prctl: arch-agnostic prctl for shadow stack
Message-ID: <ZvyCC7tJT7QoKO+D@debug.ba.rivosinc.com>
References: <20241001-arm64-gcs-v13-0-222b78d87eee@kernel.org>
 <20241001-arm64-gcs-v13-4-222b78d87eee@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241001-arm64-gcs-v13-4-222b78d87eee@kernel.org>

On Tue, Oct 01, 2024 at 11:58:43PM +0100, Mark Brown wrote:
>Three architectures (x86, aarch64, riscv) have announced support for
>shadow stacks with fairly similar functionality.  While x86 is using
>arch_prctl() to control the functionality neither arm64 nor riscv uses
>that interface so this patch adds arch-agnostic prctl() support to
>get and set status of shadow stacks and lock the current configuation to
>prevent further changes, with support for turning on and off individual
>subfeatures so applications can limit their exposure to features that
>they do not need.  The features are:
>
>  - PR_SHADOW_STACK_ENABLE: Tracking and enforcement of shadow stacks,
>    including allocation of a shadow stack if one is not already
>    allocated.
>  - PR_SHADOW_STACK_WRITE: Writes to specific addresses in the shadow
>    stack.
>  - PR_SHADOW_STACK_PUSH: Push additional values onto the shadow stack.
>
>These features are expected to be inherited by new threads and cleared
>on exec(), unknown features should be rejected for enable but accepted
>for locking (in order to allow for future proofing).
>
>This is based on a patch originally written by Deepak Gupta but modified
>fairly heavily, support for indirect landing pads is removed, additional
>modes added and the locking interface reworked.  The set status prctl()
>is also reworked to just set flags, if setting/reading the shadow stack
>pointer is required this could be a separate prctl.
>
>Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
>Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>
>Signed-off-by: Mark Brown <broonie@kernel.org>
>---
> include/linux/mm.h         |  4 ++++
> include/uapi/linux/prctl.h | 22 ++++++++++++++++++++++
> kernel/sys.c               | 30 ++++++++++++++++++++++++++++++
> 3 files changed, 56 insertions(+)

Reviewed-by: Deepak Gupta <debug@rivosinc.com>

>
