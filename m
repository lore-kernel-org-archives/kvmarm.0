Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3675A619B7
	for <kvmarm@lists.linux.dev>; Sat,  2 Dec 2023 08:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="aUzPAb33"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40b552deba0so30382585e9.1
        for <kvmarm@lists.linux.dev>; Sat, 02 Dec 2023 00:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701504756; x=1702109556; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CVX2kpuxMR/gQOGxwhkAyQ2ljhTWu/mzS3efRZJyhSQ=;
        b=aUzPAb33AMwDqVkV7CdVAxHEOYCfFmk/eEsngrep82QmNU0GRoSzwiyTj625DVANAQ
         uLnATI3l6PqCgKXdn9hlknA6Kcj3ilmkHS9WcA+4BhwOavav0Op4ZR/prnyBsblfg75r
         k3T/G+6FzW+DNqpg0QDBt4FaHzMLgZBEvUAnJL3bqlGAEq246AH+XYgy89Fp0BKqGaef
         GVifd3MlKnuZ7/RErj5Q+UegfwD/IoBs5o4UCCdlEFadDPsGVsp7DJyLaWUFnHq66bzw
         QOlQ9XOlbQMIeCS95/bjDaFh+wxRsCZcoljeb/7Qwe0+2Z4bGhW4J53QTJvOy3MnKH6w
         c29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701504756; x=1702109556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVX2kpuxMR/gQOGxwhkAyQ2ljhTWu/mzS3efRZJyhSQ=;
        b=qA7XMd+ckWJhfmX1LgOl/Hzl0sTt+dtXl/af3nL3yuprBAwSEi+xfoTu840+6RJstX
         n7oyBEdhe4ufSLEpHbKk26wEk1MNk6BNB6yKk45kE3nG4x3vX5hIkLoTiZmZS6mipcpM
         jSjQ5YR7JoJVgu8ZisE7BkGY9QIHB0XPwf0jifxG3Ht1LthDorUW1VOQbBKc9jtpOSsI
         9pgx3od21DuicA44AitmCUogOI2LUfRq8mOsKzWnbpzVeuDnwNyEMoisOgMj1tKaI6KR
         PNCV0SxoYw3Gib5/BSFPHsIaWWuSdaAi/wauCb9ev9U5BHVNDhfyy4zze4MFyyPvfJMl
         Ar6Q==
X-Gm-Message-State: AOJu0YydLDMi2/Cavg8jMw8ERD23fD0LgXFBmELxczkRsds/opHmUydo
	G/ivgUSHcnRU721Q8fJ3P8OuqA==
X-Google-Smtp-Source: AGHT+IEUK+ue+JgPyJTnysv1yet0GgFn+9iBizzS8rLx+WfhJQ9tDiQnhK4ki/wLaMJ6+T1dIvWEwg==
X-Received: by 2002:a05:600c:21d0:b0:40b:5e59:cca3 with SMTP id x16-20020a05600c21d000b0040b5e59cca3mr835423wmj.132.1701504756302;
        Sat, 02 Dec 2023 00:12:36 -0800 (PST)
Received: from localhost ([2001:9e8:8c06:1:fc31:ac12:b4b1:32fe])
        by smtp.gmail.com with ESMTPSA id t20-20020a05600c451400b004094e565e71sm7852194wmo.23.2023.12.02.00.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Dec 2023 00:12:35 -0800 (PST)
Date: Sat, 2 Dec 2023 09:12:34 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
Message-ID: <20231202-95468f21e7d2d4c90f475079@orel>
References: <20231130182832.54603-2-ajones@ventanamicro.com>
 <ZWjfjAnZcomGa1Ey@google.com>
 <ZWoE_55_6q7lqJvo@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWoE_55_6q7lqJvo@google.com>

On Fri, Dec 01, 2023 at 08:08:31AM -0800, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Sean Christopherson wrote:
> > On Thu, Nov 30, 2023, Andrew Jones wrote:
> > > A few __TEST_REQUIRE callers are appending their own newline, resulting
> > > in an extra one being output. Rather than remove the newlines from
> > > those callers, remove it from __TEST_REQUIRE and add newlines to all
> > > the other callers, as __TEST_REQUIRE was the only output function
> > > appending newlines and consistency is a good thing.
> > > 
> > > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > > ---
> > > 
> > > Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> > > MAGIC_TOKEN change)
> > 
> > Heh, and then I went and created a conflict anyways :-)
> > 
> > https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com
> > 
> > If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
> > MAGIC_TOKEN conflict.
> 
> Actually, I misread the patch.  I thought you were removing newlines, not adding
> them.  My thinking for TEST_REQUIRE() is that it should look and behave like
> TEST_ASSERT(), not like a raw printf().  I.e. the caller provides the raw message,
> and the framework handles formatting the final output.

Darn. I'm not sure how I forgot about the other TEST_* functions. We
indeed want them to be consistent. I'll reverse the patch. Also, it
looks like when errno == EACCES, test_assert() will be missing a newline.
I'll do a quick audit of TEST_* functions and their callers this time
around.

Thanks,
drew
