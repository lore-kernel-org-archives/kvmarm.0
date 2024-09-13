Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08581714B3
	for <kvmarm@lists.linux.dev>; Fri, 13 Sep 2024 22:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726266548; cv=none; b=swswYOUcDdjzZFyPMVE6nOebpva6JD6HcZ70hMo4MdnvbfO6uCmvOK99AP/vCqdfiJZUrh1iMt+rzeYppk96tgLmc1KinKOgzXOQIC7yCa2wH/i6Af+pdaGkbjrJ05NZY8E/P4puUkIuEnrhw480M48hqMb1+KCfulDfmJ8NfEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726266548; c=relaxed/simple;
	bh=IvzabYSh+pHeeHd+hD1FOErHkOCPfysKNWasduDGcwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yf+ULfpcQnZMtjnmyyKnpX3SR1/kvnlPB4UYsd7mAqUsk5hPHCC9hRJN/WDCz+adaqf1EsokdjAVRG/1ZzsKPIL4mRbY+FgY/PXeLqV56X6sWNNGAaUWoYYJRROr9yqEb9ToYi8Y90JO4O5auFIxKaFFsaN+5+nG8yOLsohyyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qqQl1plz; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qqQl1plz"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d446adf6eso170365966b.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Sep 2024 15:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726266545; x=1726871345; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvzabYSh+pHeeHd+hD1FOErHkOCPfysKNWasduDGcwU=;
        b=qqQl1plzrJD+sMJqMm8cfZD+leJobnucL7/9+POgZtsBK79djQRWGM7WzqOdwYDI5+
         ac6yWrb7ocx9iiDAZuBoseb3qA7cXDTDl5puiVBjJI4mCmafdV7D2GScQIJYYFu7TdB4
         BXDOJwJtiLHDawzQ8aK+97d1s1UhIE7Cm2oiJ+U/u8uYSjmF1GIl9MR/QAyKfu+OQj9l
         4YyiENpSCDl/ukXnS6zbdA8DeXtsMpsd/x8GJcrW2XyyAk1GQck8BVnXOXqhkFmcBoIl
         3+mYA2lyGpIllsEX8F4d+Z3tAYvU9/xTiQodfDHmxzUTrSihel4l3GF7ING5Qjjxrm1y
         zmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726266545; x=1726871345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvzabYSh+pHeeHd+hD1FOErHkOCPfysKNWasduDGcwU=;
        b=ZUDr04FMR7X/bv4UNRHLBMhFT13kb5Pfs7L9Ai/eEqT1H8/P8EA8JxVlrbSkWEn0xA
         GzqRW4/z/Oz5w90rN8JOl5jrIR9ybk8AbQ96ZbHVQkbh9YT0AXVfJM/2ZCLuMGevT/mC
         gf9myYf4KGtihpJCB5ulged1A3ZMCc5oM3k64mReoWqyOk7+iAKCGCk9XlBxjHWKIcOI
         PQlTaY8RZtR4sUmqGyjBek9TsYfSjPuQ666ww5Jw9w5V9eFsW902NpdPe6OxCeiBEVhK
         jD4P+vKUD5Ebo9AuBRBAGfgx1xAt+lubHxp4cozXXDzNJ4f9QfzFwjmHHNftSEahNXzZ
         AIBg==
X-Forwarded-Encrypted: i=1; AJvYcCWpog+lqxprEmb8KnWLS1/Km9Y7noH9aafYSbxfKUdOLB/U6BIDUFLXDM54dBtCV1Lkwa0twpg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKmfsiwOg/fuffcNlT5WUH+NMeJU3lK64nka+h4VkgqyRTI53D
	oS5QgV648YJMsXCzNQcPn4cGOFMZqv0UVUdzoQjysXUrtkn3eLcMClCL/y4SXRkDg646zzljmO4
	AdWIKPb97/teoSoP9Ocg0h+fsZZ1kh6WxuOw=
X-Google-Smtp-Source: AGHT+IGz4HrZgTUzfTrywk01MKDCVDNjEpFYnYsoSdttd9K4GG6wqFFHYTex9HUp/m1OnssmyakcUkoL+HyjINOHmus=
X-Received: by 2002:a17:907:f154:b0:a8a:8dd1:b2d1 with SMTP id
 a640c23a62f3a-a90480c79ddmr413023366b.55.1726266543519; Fri, 13 Sep 2024
 15:29:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com> <20240911093029.3279154-5-vdonnefort@google.com>
In-Reply-To: <20240911093029.3279154-5-vdonnefort@google.com>
From: John Stultz <jstultz@google.com>
Date: Fri, 13 Sep 2024 15:28:51 -0700
Message-ID: <CANDhNCr_cCeLdqMTwNwgCCeiPifSsew_-hwOC-WY_-PvaNiC9Q@mail.gmail.com>
Subject: Re: [PATCH 04/13] timekeeping: Add the boot clock to system time snapshot
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	"Christopher S. Hall" <christopher.s.hall@intel.com>, Richard Cochran <richardcochran@gmail.com>, 
	Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 2:30=E2=80=AFAM Vincent Donnefort <vdonnefort@googl=
e.com> wrote:
>
> For tracing purpose, the boot clock is interesting as it doesn't stop on
> suspend. Export it as part of the time snapshot. This will later allow
> the hypervisor to add boot clock timestamps to its events.
>
> Cc: John Stultz <jstultz@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Christopher S. Hall <christopher.s.hall@intel.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Acked-by: John Stultz <jstultz@google.com>
