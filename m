Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6057123BC6
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:12:01 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-53fa455cd94so884271a12.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 13:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1691698320; x=1692303120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgXTJGJNIG5brUNilbYvmAufJFTfjCt86nj6wBgTVtw=;
        b=fyUQ4xBfwdZ9Y1ncwPWe8KTy87SugAY04QbysuNfCKESxljSeA//xKB0ll7SV9MfBn
         Qolk9WYlCPFGiQVFIlruea5ANAIMyj2MFfbdlKAdMKJ07nVHWugx38DTOanRdd2Cvm89
         JEkZdTPYMsehHWh3x07+sxbrflynbDh3hIrFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691698320; x=1692303120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgXTJGJNIG5brUNilbYvmAufJFTfjCt86nj6wBgTVtw=;
        b=FjUAsRGUszDVe7g7MZSErkJP0AUfTbD5uHvUosu/zBcugyyxQvHz9txrCfPzn013LQ
         42KagNGC/Icdt0GElDehzWFcM9qnIPh8FgKSGWjCF3I6cMYXNQTH7AFwJ3eqJTONdZSp
         vOh5RwSegW6L3b6F7Np1aF53Miyd4p6j6kc5G4s7/IUQ32tGID0F/oxaNagEYbbBy2hw
         VQ8iUPreLqYAX3z6zJSkLac4jwA49tzx/WNPqOxFLW0wWdQ/VS2dW0osVxO0ovXLE5k4
         jzs3KbwUPEB8aBuwjhKn98Dzi4NIbaIa48vgPJJwvMPTKZjJFw3od2dDI/nnB/iP90nG
         8xKg==
X-Gm-Message-State: AOJu0Yz9KT9P/wW/UYbgY4MfPcGIabo7Lc/13/js5Zs9tcaypH+oeqan
	zMsJWnsoMfnkC10OGncoV/Fbxw==
X-Google-Smtp-Source: AGHT+IFPUbfQ62us+66kx+c9LMghiGBoteLeh6oMSfQPptLuZm4cxwBZSfUhKnCZaZrURJ2FlP0dLA==
X-Received: by 2002:a17:90a:5d91:b0:262:f09c:e73d with SMTP id t17-20020a17090a5d9100b00262f09ce73dmr2794613pji.34.1691698320688;
        Thu, 10 Aug 2023 13:12:00 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a1a4500b00263f446d432sm4004127pjl.43.2023.08.10.13.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 13:11:59 -0700 (PDT)
Date: Thu, 10 Aug 2023 13:11:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Marco Elver <elver@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com,
	linux-toolchains@vger.kernel.org
Subject: Re: [PATCH v3 3/3] list_debug: Introduce CONFIG_DEBUG_LIST_MINIMAL
Message-ID: <202308101259.D2C4C72F8@keescook>
References: <20230808102049.465864-1-elver@google.com>
 <20230808102049.465864-3-elver@google.com>
 <202308081424.1DC7AA4AE3@keescook>
 <CANpmjNM3rc8ih7wvFc2GLuMDLpWcdA8uWfut-5tOajqtVG952A@mail.gmail.com>
 <ZNNi/4L1mD8XPNix@elver.google.com>
 <20230809113021.63e5ef66@gandalf.local.home>
 <ZNO/pf/pH5jJAZI0@elver.google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNO/pf/pH5jJAZI0@elver.google.com>

On Wed, Aug 09, 2023 at 06:32:37PM +0200, Marco Elver wrote:
> On Wed, Aug 09, 2023 at 11:30AM -0400, Steven Rostedt wrote:
> [...]
> > 
> > I would actually prefer DEBUG_LIST to select HARDEN_LIST and not the other
> > way around. It logically doesn't make sense that HARDEN_LIST would select
> > DEBUG_LIST. That is, I could by default want HARDEN_LIST always on, but not
> > DEBUG_LIST (because who knows, it may add other features I don't want). But
> > then, I may have stumbled over something and want more info, and enable
> > DEBUG_LIST (while still having HARDEN_LIST) enabled.
> > 
> > I think you are looking at this from an implementation perspective and not
> > the normal developer one.
> > 
> [...]
> > 
> > That is, if DEBUG_LIST is enabled, we always call the
> > __list_add_valid_or_report(), but if only HARDEN_LIST is enabled, then we
> > do the shortcut.
> 
> Good point - I think this is better. See below tentative v4.
> 
> Kees: Does that also look more like what you had in mind?

Yeah, this looks good. My only nit would be a naming one. All the
other hardening features are named "HARDENED", but perhaps the "ED"
is redundant in the others. Still, consistency seems nicer. What do you
think of CONFIG_LIST_HARDENED ? (The modern trend for Kconfig naming tends
to keep the subsystem name first and then apply optional elements after.)

One note: do the LKDTM list hardening tests still pass? i.e.
CORRUPT_LIST_ADD
CORRUPT_LIST_DEL

> [...]
> +		/*
> +		 * With the hardening version, elide checking if next and prev
> +		 * are NULL, LIST_POISON1 or LIST_POISON2, since the immediate
> +		 * dereference of them below would result in a fault.
> +		 */
> +		if (likely(prev->next == entry && next->prev == entry))
> +			return true;

I'm not super excited about skipping those checks, since they are
values that can be reached through kernel list management confusion. If
an attacker is using a system where the zero-page has been mapped
and is accessible (i.e. lacking SMAP etc), then attacks could still
be constructed. However, I do recognize this chain of exploitation
prerequisites is getting rather long, so probably this is a reasonable
trade off on modern systems.

-Kees

-- 
Kees Cook
