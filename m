Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DB653A2
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 09:11:28 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-3fe4ad22eb0so15997475e9.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 02:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691745087; x=1692349887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=msB7XSMQKNAACWPZ/GwjszE60e79zmFAGxGoY+G/BRc=;
        b=xOeEvMhu065euw6JTBbCi3NKxbF/ibI3VYKQjJsXrN9eEzAcwPJa9ZnxTQ4z2asNNl
         6JO361GRMRLAA/RszIe37D1XCr3KY5GikzAht8IKRTkCGL1HuBWAVjX8uMv/uXUmdaEF
         ohsEPaFCEMuvHl7Hj7ImY++OTJHHmo00++qYLerpnk7AeTnwUoDqBokIfCxZVUOo1KHQ
         nr7U1Ygo3yHCNooJDk8UqFM/Nd7f6Nyf5UVqd4GYsgcbkQycExptlTRFpeau/CbUcmYu
         TlTjVMC/gUileFVwC++uirf7cUiAh+Hy3KU2OVxSmhLfUOx/srqqi4uydryT+0Uoz5sX
         Cg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691745087; x=1692349887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msB7XSMQKNAACWPZ/GwjszE60e79zmFAGxGoY+G/BRc=;
        b=XuuIvEPA3bRtDjcBh/kzc/6HedqMR/IzJrXIS6dQw4rQkn9/hCW22wZMHgB2YfovYt
         g6UKyWUqlyx1rmKX5nh9iLQjdqBOVhiKjd/PAmJrIIZMcaabrsbFQI9hhb3Mfa1xAq0q
         631QtlrLx+VtcQEsimo0r/bpSfWpPh15UTGyS8m6+Tx6n8GgImRhOLwVJrLOxnEB8z2A
         wUbtuIKHEZj6/7ngiP5GFf47WCeP9P3YInF8bk8FE7Qjw+91Uo0Sf8DuB9bPRK3llS3c
         dvoaZ7gDfMW1QtN/lPJ1PqJ1CPgHydllY8fbvBTSSbndCqXiU0KaPHYsXFftDxPqSeaB
         Olgg==
X-Gm-Message-State: AOJu0YynZs8+ZaahYoMAOZLB0EAelooPAZKl/U8pD0FPRBepo6AQo3Nt
	AHues2DqSBc9NFKpzVPiZLq/4PX1Q2QC92Vr++4I+Q==
X-Google-Smtp-Source: AGHT+IG0mmKs/Ojd86c5RsrBdtIz3U/1JKmzd/I7IPgCTgOgVi6XjJz1KDzwaNq3PIN/DCWY1JE0vE3/JbnwdiJ7T7c=
X-Received: by 2002:a7b:cbcc:0:b0:3fe:10d8:e7fa with SMTP id
 n12-20020a7bcbcc000000b003fe10d8e7famr1164390wmi.41.1691745086680; Fri, 11
 Aug 2023 02:11:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808102049.465864-1-elver@google.com> <20230808102049.465864-3-elver@google.com>
 <202308081424.1DC7AA4AE3@keescook> <CANpmjNM3rc8ih7wvFc2GLuMDLpWcdA8uWfut-5tOajqtVG952A@mail.gmail.com>
 <ZNNi/4L1mD8XPNix@elver.google.com> <20230809113021.63e5ef66@gandalf.local.home>
 <ZNO/pf/pH5jJAZI0@elver.google.com> <202308101259.D2C4C72F8@keescook>
In-Reply-To: <202308101259.D2C4C72F8@keescook>
From: Marco Elver <elver@google.com>
Date: Fri, 11 Aug 2023 11:10:49 +0200
Message-ID: <CANpmjNN84DGUSutk1FxcVmPGDhgVa2PrOuFTzGYu92mv+WXUeQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] list_debug: Introduce CONFIG_DEBUG_LIST_MINIMAL
To: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Aug 2023 at 22:12, Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Aug 09, 2023 at 06:32:37PM +0200, Marco Elver wrote:
> > On Wed, Aug 09, 2023 at 11:30AM -0400, Steven Rostedt wrote:
> > [...]
> > >
> > > I would actually prefer DEBUG_LIST to select HARDEN_LIST and not the other
> > > way around. It logically doesn't make sense that HARDEN_LIST would select
> > > DEBUG_LIST. That is, I could by default want HARDEN_LIST always on, but not
> > > DEBUG_LIST (because who knows, it may add other features I don't want). But
> > > then, I may have stumbled over something and want more info, and enable
> > > DEBUG_LIST (while still having HARDEN_LIST) enabled.
> > >
> > > I think you are looking at this from an implementation perspective and not
> > > the normal developer one.
> > >
> > [...]
> > >
> > > That is, if DEBUG_LIST is enabled, we always call the
> > > __list_add_valid_or_report(), but if only HARDEN_LIST is enabled, then we
> > > do the shortcut.
> >
> > Good point - I think this is better. See below tentative v4.
> >
> > Kees: Does that also look more like what you had in mind?
>
> Yeah, this looks good. My only nit would be a naming one. All the
> other hardening features are named "HARDENED", but perhaps the "ED"
> is redundant in the others. Still, consistency seems nicer. What do you
> think of CONFIG_LIST_HARDENED ? (The modern trend for Kconfig naming tends
> to keep the subsystem name first and then apply optional elements after.)

Naming is a bit all over. :-/
I agree with the <subsystem>_<suboption> scheme, generally. I think
initially I tried to keep the name shorter, and also find a good
counter-part to DEBUG_<suboption>, therefore HARDEN_LIST.

Let's just change it to CONFIG_LIST_HARDENED, given the existing
"HARDENED" options.

I don't have a strong preference.

> One note: do the LKDTM list hardening tests still pass? i.e.
> CORRUPT_LIST_ADD
> CORRUPT_LIST_DEL

Yes, they do. Though I need to also adjust BUG_ON_DATA_CORRUPTION to
select LIST_HARDENED, and the test should check for the new option
(which is implied by DEBUG_LIST now). There will be an additional
patch to adjust that.

> > [...]
> > +             /*
> > +              * With the hardening version, elide checking if next and prev
> > +              * are NULL, LIST_POISON1 or LIST_POISON2, since the immediate
> > +              * dereference of them below would result in a fault.
> > +              */
> > +             if (likely(prev->next == entry && next->prev == entry))
> > +                     return true;
>
> I'm not super excited about skipping those checks, since they are
> values that can be reached through kernel list management confusion. If
> an attacker is using a system where the zero-page has been mapped
> and is accessible (i.e. lacking SMAP etc), then attacks could still
> be constructed. However, I do recognize this chain of exploitation
> prerequisites is getting rather long, so probably this is a reasonable
> trade off on modern systems.

Sure, it's a trade-off for systems which do have the bare minimum of
modern hardware security features.
