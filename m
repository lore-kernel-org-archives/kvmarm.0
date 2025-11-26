Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8777B221DB6
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764176787; cv=none; b=SWKn73nTozMPkYi50uWFw5mdwqCBICA4hLfGLpNUtSSC3CBaBJPANKdFltv5gXKDnKCtz6fvVUWJkOU3iYzGymYfu1RhPBxUweXfLMAUhI0lRENLhDuKLFeID87tx0NIFFOo7Jn00tedUpItAXXIv5CyFM51VHRjkycW7DQU26A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764176787; c=relaxed/simple;
	bh=BrjucNnSWkm6XnhUdikP76kJKoaY9byQXleH9u92HsA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fYUkgHu7dYDNqkzZy4nhx/lhkiiJQ1uO56Um+fSw/TpoT5v+iT9ePH7AW5QeZXCXxekrVd+6tRXwZpCbGGxdPnoNpt2NaIFtwuw+pZQGCHnJ9dDBA17rNbU5gDC6seXX/AsMwMhb+U3JHbKBxZzpJ82I9ns6glfLjPOHxd1pRoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BUhOvrVa; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BUhOvrVa"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4edb8d6e98aso466541cf.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 09:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764176784; x=1764781584; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o60MW7S69uuqBYywy0KQnM0R58oP3Hl+TM2jep19u1Y=;
        b=BUhOvrVaX8U3qa4+94Hvy7ea1Ja758zvO8Wec9lUnt28m3aJrAaSxrqhTliyZ0ZBrd
         vOLQ1N0ereXTGy0YSGjt9sIv/BxVKwJ7ZZ6ytSuhgR3NubcPYsJPEZNEFX9+uux/8utD
         kzvEhWEq3EQbxjlThm99cvWFaH6PUM6LFt/ni7PnkQtsyIDtToiPDNKmjm9LRwZ3k5yZ
         RfwrZuybAEbEB8VwRZZQfFClI5Ck0TjaQjU9o5GxoS1J6WtdSlPykoOyd2bSomWbW5FS
         4seGpWMToSt8YVsdkBLc+wQ3Jcobl/PCEaOrgkdNfpRBFUqBmY9MP2iuo6J3eTolEWXL
         vFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764176784; x=1764781584;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o60MW7S69uuqBYywy0KQnM0R58oP3Hl+TM2jep19u1Y=;
        b=lpocHoDSOZ6v4FJKzmu8kmtAAAz3wv60JTw+wkLYJ6Y4PrrM4usmw/8/ewrpNHf/4r
         cMg6EE1c2+aprHXD7pqT3GSRRmv111CbzF+fiUlCdOXm+n1w81+JT8XnNvP2gQDrMqGI
         p23GrDWgW7Bvw3sGHswX7zKmVvzXQZ3RVsq7k06BVkfyGaKIpPGew+ppzwxUCZz2SnqO
         YwSY9MhtX/Bg8fv4gFpDfJLljw9oU5FC0cSEKgxIi+SaIn+nGdDSWsVhYoXlq/45C65E
         4Y0afjH5CxQfp2ZDjRBEAqPhUPApdqy7TGKGdvy/zAQ9fc2C84nh3AG5S2vg3CTR29hC
         zwHg==
X-Gm-Message-State: AOJu0Yx8la7xED+1auep3vdlq2MvD7qioO4cGGzvHKZucRlnebm8a8F8
	ks8qMemM9B0ZPRax1PCMDeZng7flX0fe9p4iwdDv9DIobRUOGPwtcHziS1z3yBgWQGgNmNM+2L/
	lQlIBOW0Hh4vYSlbPfbxhaNZUZzF9gZY1PzuxISwo
X-Gm-Gg: ASbGncuMDzQ/c8F19Tb+R0gi5KwKWFnLzq958BkBtw1DdPNw3hT67ISxSl2ZJql7eax
	VgcnMUiysoOrrPvMCs1bpzYR1Xf6n0tBqCAg0IJmH7BNYxoGyjULUOpp9WOQp4+HbuUvGcUKpvw
	wgmn0wbdvdiSRPyyDAfccc/RtA0K5W8FU0QsRGR1TfgBPbBNd1N0wkbKbS0GK0YAG7CyW0HQ30M
	zX6U1Tf9DECqiph21329Bm8Rmkyla9+2UOkzNCpPCFz5jMRBMeVO29IQwvPY45cIDT0PL0=
X-Google-Smtp-Source: AGHT+IH9tnAOFqfHE1ZUeq9aGNT99DojsOvMG9Z95k/L2aVsl+KbVPrslR7MPF1R0Fo4pkQWgFDJOxqw7DlE+AJKQwI=
X-Received: by 2002:a05:622a:1496:b0:4ed:b665:3779 with SMTP id
 d75a77b69052e-4efc6c8b73bmr5092981cf.16.1764176784132; Wed, 26 Nov 2025
 09:06:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-6-tabba@google.com>
 <867bvdqd4m.wl-maz@kernel.org> <CA+EHjTxPxscVZryCoVAZYebgD82waEKiv0Z-CFG6H+CW3dAbXQ@mail.gmail.com>
 <864iqgrek1.wl-maz@kernel.org>
In-Reply-To: <864iqgrek1.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Nov 2025 17:05:47 +0000
X-Gm-Features: AWmQ_blQ8brwZqwItq1-TvVlfw6eYa-PZX9_b2kaFWro8aZCC6KtramSGHgSbtw
Message-ID: <CA+EHjTxJtxvJYCmaen8SgVVECeRZym90_m+AgJZ9txoswDsgSQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/9] KVM: arm64: Include VM type when checking VM
 capabilities in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Nov 2025 at 15:36, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 26 Nov 2025 11:00:47 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > I agree, but I don't think this patch changes this behavior. Later on
> > in this series we expand the check to apply to non-protected VMs to
> > also restrict features that are not allowed in protected mode in
> > general -- something that until this series we didn't have.
>
> Ah, you are correct. Apologies for being so thick.
>
> Still, I think we need to do something here -- the whole extension
> check without context is just broken.

I agree, but should we handle that in another series, since I don't
think that there's a straightfoward solution for this?

Cheers,
/fiad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
