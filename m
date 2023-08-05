Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F3180;
	Sat,  5 Aug 2023 06:30:36 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-5844bb9923eso32126727b3.0;
        Fri, 04 Aug 2023 23:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691217036; x=1691821836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1deVdX+LzYEoDf7vsg6ItDydaxzW1rpkypTtAc77Ldo=;
        b=hocI5qRhcmyXSgjK0+H06F/DigjmW9zNcUTkw8bGbSP8Up9QmREEicoxw5/UM8Y3Wu
         x1veUnSDlmxpiJ1nxJwRz9HMBJbnvHiqgVRwTQ5Sw20WUlAFxfkVgRv6UURPzyAOTt9+
         QN5GPOEvnmpVYr7bgREmtbFNtLBl6NS733cqoHaBGoHFy9Mik4gjgoLktMX1cB+t37xQ
         Lx+pIfpUygiBfoUelRcVmMVu3NN//KBXX/iD4MT3f/4rBmwCo7UA2kYhfJiE31zK63uF
         +1FUTwhCUfPlSL0t0ebPugTUmztYwYd4zKpZg4BCVqdpGgL6rFPhosDG9vY1XnckORFi
         RfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691217036; x=1691821836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1deVdX+LzYEoDf7vsg6ItDydaxzW1rpkypTtAc77Ldo=;
        b=lHtwKY7/ECqZQm9lu7hDJxwzptTGmnzRrMfVvgDVl9XtgPoWMuCitCdH10UJSiS+Xk
         g4E7E0FG1yJvbamdWMVIFr6iBCIO+1EH0z8gWGZqBFRF5A8Ld3CSI3khJIF2BHXC23fk
         wSJls6YWj1+nDjrS65Iw4WlE0HxneebBvLREolcD/6FuwEvfPE/WuJ2GohOHJf4iJJEi
         /+1/HNupBHhz5mCxGgRSKJTtAXu4XV3OCxLN4pdzIypbEHSSSzzwDTcaQr93GUWOnVwi
         G433ZHUNx9Wa17zez9XlAxlRN+GqTOLkPIKwk84BDhhLZx7KvsDHzv4szbNAt5HTD4mw
         wxrg==
X-Gm-Message-State: AOJu0YxcY1Y2jq8/zgM57GonOUa9GJSd+pqV0hH5SFj4Gp5BtpQfqdvz
	luooRAGbpzmkW9Zp/RUM8OF+4S6g9ObiJB5dJwY=
X-Google-Smtp-Source: AGHT+IGMjrTZavQsDldYd9gbdtphIVYBVyARzYtz6BxfZv89hhYckKzwAXTsUhzzg17ZR58DVPSYS4QbDnBC3XWXbnw=
X-Received: by 2002:a0d:d655:0:b0:586:9f60:72f6 with SMTP id
 y82-20020a0dd655000000b005869f6072f6mr5332389ywd.39.1691217035955; Fri, 04
 Aug 2023 23:30:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230804090621.400-1-elver@google.com> <20230804090621.400-2-elver@google.com>
 <20230804120308.253c5521@gandalf.local.home>
In-Reply-To: <20230804120308.253c5521@gandalf.local.home>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 5 Aug 2023 08:30:24 +0200
Message-ID: <CANiq72k_=aPidmk-BRVeKfsU=5FLkDxZN5iQKtHn3O1wZi2MUA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] list_debug: Introduce inline wrappers for debug checks
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>, Guenter Roeck <linux@roeck-us.net>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 4, 2023 at 6:03=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
> Can we give actual real names to why the function is "special" besides th=
at
> it now has another underscore added to it?

+1, some docs on top of that can also help a lot to explain the
intended difference quickly to a reader.

Cheers,
Miguel
