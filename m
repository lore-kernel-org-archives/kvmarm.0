Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DA528DF42
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297806; cv=none; b=bdMX8N0lMqPt7dUhlJQKPSONdw0zMY0Gnh3FN3hY8ihDKAtuEQ/fRhRZFFbSNQM+He49g9quA3afgIhcY/K3zOq7F+TrVQ2WacQaP6G9zTtc2MhAfO+uziqI4ldY8KufAAzsgHY5OYOXeKNL3xWcVeY+OPCIj9y+irPXn0mqCeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297806; c=relaxed/simple;
	bh=ltzjsZ3Y13JqtrnFJO+zsCen5wBONE4sgDpdbeqPl3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HceR8qFy7s2JuuP1m/D7/IrEKAKtKkkGxBXEefecW3t57/I20sGEaUM8G44Hqw45ELI1vI66HZvT/e+xw4wr6o6FfTgrQI5QObBgoltFqyV08H4/5WgK7z1+2HBwIldJ4rx6HNC+gW13/1bShCouRsS1gPz/XPRHb3AFO7FOPrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cj3C4sd4; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cj3C4sd4"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3df2fa612c4so530685ab.1
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 08:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751297804; x=1751902604; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3GKh4o61b7jyIv0Cvm8DV094/Zex2HvCho/VCSf17U=;
        b=Cj3C4sd4rwPTXezuSYwf5vTGI4Vk38btqPW9mzwfBUnLo4sTj/j3HUeZEfF6+3xMVn
         ly3WHXTs7/elnlmF4LCVmq9cl4wSrFiS+IkbkOfowQOxPUvlXZ0WkpxP+YenUsClRScM
         5LJtU74f/bK5OgL46HcAXFs47pyehlgJWcW3UF+0pF04psV/2thkn0XndXPnkrw4wZMY
         VCrB0aFLEuT7bM0pJQoBmkEo++MlUc3tUBfZsXm+IMoOhPnPtHeYNz23olWbFW3R4aOF
         pV/8rm1uDbZm6l3m94uf9vyk2PeCqMcHtC+P80Ko0e5ve1dUPPhgnREGJkvjCDDFWlOr
         RqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751297804; x=1751902604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o3GKh4o61b7jyIv0Cvm8DV094/Zex2HvCho/VCSf17U=;
        b=MafQczN6ppj8z9N8OIhB41M+Ak4OVcQlFewAUvr78YZXaeZMPq4/vt3afBCfq8B3An
         wdQL3sDCVmyv2xe35KKYgX1Uj2u7PqoL67Tsse7sIrxvhS6Hcq9tJ1fyQnSeNGdnH/98
         dLl0Ojdv1mayu3N2yEAFcHs8wpvKAmJohaDSnKbeaXtff1Pn8W4AzVSJILuA2Rbwk7w4
         s/1txs9/l0TrbLbnVRoSgxKb+xut5kpDzn6L6T+u/8dfyDu3q9Ud4S/c9wajlgMkqXLT
         RsHUwZr/i/O/P8wjrmH0VUtXI2R1Zn3ZeBEhIhW9J6rbbEcEMwUNTZNj2X89LxrMXli9
         VAqQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0KOe4Z/3PLs6ykj9VqX2vNqqq7SuDZnmIqw2MEmE1sBX55rhH6GxlpnScDHjNVzEVEk+DvCA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJCeYgiehgor2wPnPCJYbcjkMyOhQV4GIMmlHgLUz+G3wKCqeN
	wq/VwRTUJk2gmS2RDS40wa7iTXkh/ElvO20AyYbjrcaE3TLNZblOdBJW8XmklOKq8/ObkPlXEUB
	GWezYNuqTQbjxyPWBTVznEe9+rzgGLSibrM5UonDd
X-Gm-Gg: ASbGncs29pDyV+z1Hv0t1Eaj8b2MqRClCMcu+/2oocmvWfXeBpPY5ZSTJT2JaZxcpaz
	KeZstcKAXegR9VMGcoMaMd4OnXvzu2IY7/zg78jvej2VCuIcomu27a24AfwHV/lJ2XpRzFGvgnw
	81y0lByb3semjFdhB4OWEnnu7F3sVFfYXMb8TZERHvmVCTZvABTuDEhphc0sY/sz5iDxRLaBo=
X-Google-Smtp-Source: AGHT+IHCeL7uDDU5JOMczoHemzrfltO8zFE7mNOcumLGxZUSHGclDw+KN2fxow6X8OtdYvZ/ZfmsVer2qBLOgVRnCKc=
X-Received: by 2002:a05:6e02:11:b0:3dd:b59b:8da5 with SMTP id
 e9e14a558f8ab-3df55381c7amr8226995ab.0.1751297803769; Mon, 30 Jun 2025
 08:36:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org> <20250605-james-perf-feat_spe_eft-v3-8-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-8-71b0c9f98093@linaro.org>
From: Ian Rogers <irogers@google.com>
Date: Mon, 30 Jun 2025 08:36:31 -0700
X-Gm-Features: Ac12FXzGjtf9e7aPdAU9e9fczw6vLUTz8vKdx9vV288aJS8GZ_7quQwpeJqa1_Q
Message-ID: <CAP-5=fWuKrtRy5NdPFivjSKx-fbw6P49QFepg1-1qUB=0guu_Q@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 3:50=E2=80=AFAM James Clark <james.clark@linaro.org>=
 wrote:
>
> To pickup config4 changes.
>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/include/uapi/linux/perf_event.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/l=
inux/perf_event.h
> index 78a362b80027..0d0ed85ad8cb 100644
> --- a/tools/include/uapi/linux/perf_event.h
> +++ b/tools/include/uapi/linux/perf_event.h
> @@ -382,6 +382,7 @@ enum perf_event_read_format {
>  #define PERF_ATTR_SIZE_VER6                    120     /* Add: aux_sampl=
e_size */
>  #define PERF_ATTR_SIZE_VER7                    128     /* Add: sig_data =
*/
>  #define PERF_ATTR_SIZE_VER8                    136     /* Add: config3 *=
/
> +#define PERF_ATTR_SIZE_VER9                    144     /* add: config4 *=
/
>
>  /*
>   * 'struct perf_event_attr' contains various attributes that define
> @@ -543,6 +544,7 @@ struct perf_event_attr {
>         __u64   sig_data;
>
>         __u64   config3; /* extension of config2 */
> +       __u64   config4; /* extension of config3 */
>  };
>
>  /*
>
> --
> 2.34.1
>
