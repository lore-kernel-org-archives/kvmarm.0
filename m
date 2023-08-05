Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F7180;
	Sat,  5 Aug 2023 06:35:55 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-583d63ca1e9so32530677b3.1;
        Fri, 04 Aug 2023 23:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691217354; x=1691822154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izJldXkK49lbGL0XLPukfeIEvUvsLq+UDkHmXV6tSds=;
        b=A707mbbrKfoL1HkqQ9fJGcWngC04eUzbvLyMt49WGL8RFVv8VVbIZrDybCgkWbyF3Z
         vBWBrqUXwI/5LR1HQvVi4keHlv535aZBqE4e/Dh3PSZ8liVnM3jGsUxBJya6dEnt46pm
         kUKIDrb+hlSRduhrPrL8dHw4HqoWOQcCe2gbXLoiQhroTv7kn9YzXEgY9nHwVBseDeXT
         PVUJUU4wde1bkvk6TsY0r3Hnjqwwhbtkd1uUhjdwnS8DvcTDcQPuTWvM2CAxHW/AJGV4
         UwlCEAtthV3zhWmSjt8Z4wfFxaTBk9UynuGfZjMU9XrEaUsC2gwLOOSdl24JTRFx4l3y
         ZMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691217354; x=1691822154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izJldXkK49lbGL0XLPukfeIEvUvsLq+UDkHmXV6tSds=;
        b=l/K79PvL9owVtRxvdOsMTf1H7OFcyLs4O8ITrZNND17GN03UPvdGUdFcq+fnr3g6ZJ
         mA+YzUQNfxfyv6gDlpFDQWqvqX+stYSO6fXyRTs8KpO95d6TkqKn69UqFLRggKLxF0qc
         s/Eoxe0RcsyKFZP8BsrbUNagDEPqlzX9OERBGvEZsUgbqlZakwVNKVHLqqhpokPKFBNg
         3XLcioUa/dIwLE7A98WLNt1VZM8l0A3JTokmNGSgvvPw9McEHwDFXolIamX/alBOq64z
         5Ia18PEfF/rdISd9/TRokA/KoA6huEno1rG6aX8SxokK4V0iLUycrDyXnVx08Wv2lXs+
         x7fw==
X-Gm-Message-State: AOJu0YzduiwL9QHAjg29l4M0RJfefY6yhSDs3byppx5DZzsZZIDgQGRN
	GNi/Wapqe27kRoLonv5Y18ph5rr4JeK/P9AB2o4=
X-Google-Smtp-Source: AGHT+IET4oIjgzL1wCDATiUpvfpr5nw9EkbuCymAifTyabQIhU5etbcc4G7i4IZn4+mmPn7hXwN8W06nR+L21IOYu7k=
X-Received: by 2002:a81:73c1:0:b0:584:3140:fcae with SMTP id
 o184-20020a8173c1000000b005843140fcaemr4139723ywc.26.1691217354314; Fri, 04
 Aug 2023 23:35:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230804090621.400-1-elver@google.com>
In-Reply-To: <20230804090621.400-1-elver@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 5 Aug 2023 08:35:43 +0200
Message-ID: <CANiq72=-o49qkW+mPW45P_+jbS2jO=5_qks14HOtzVOukb0Mpw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] compiler_types: Introduce the Clang
 __preserve_most function attribute
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, 
	Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
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

On Fri, Aug 4, 2023 at 11:06=E2=80=AFAM Marco Elver <elver@google.com> wrot=
e:
>
> will imply notrace. It is recommended to restrict use of the attribute
> to functions that should or already disable tracing.

Should the last sentence here be added into the code comment?

Apart from that this looks fine from a `compiler_attributes.h`
perspective (even if we are not there anymore):

Reviewed-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
