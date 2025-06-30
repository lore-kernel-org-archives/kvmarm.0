Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3250228C854
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297735; cv=none; b=Hja00RdLz3umpLGPlCrjpK2wmWTj4ff5O+7tIq8WZo15JX2NgnsG9uDIGlEzqqbgvnlHSUF0DyJpPUTH+Iegbtxc7nPLXswssZT04+L6Yn3StJUWm7VbUYSR6R38+cmcA3Oz/kbdJh8pXEhywAlv/06CDmwvyXgarUFJPl2YLW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297735; c=relaxed/simple;
	bh=WzUsL62s99aMQbncJlzVXJNCLYFnik+CIGI7EJNTcOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SyOVc+atXVjMMDDqOi7uX5WmAD9D4WEUtO9LUqi8AklTmU/qZfZT9j3WFiXzBck9wXZCf30cnheBSoViGka8f2O1O50K8YhI1CyvwiYOPXi3N4Qyl8QI8pEINYuZzd+6AnqALUmTSh53iQhTRtiwJ6OVoaWqnFAvhIghQLAcz44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pPYReXew; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pPYReXew"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ddc99e0b77so488735ab.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 08:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751297733; x=1751902533; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbO9psxgk55oppNmRGWDGVoNc1FLKxrpCgi5quujmE0=;
        b=pPYReXewQfQgrZNopqkadoB7OVL0aJlCCHgr7Gld1JAuCUjprshD0eLtSDwBOotpBf
         1J1gnU+yafujYjSYjsuQ8VHdPwXcbiFuHMH7MEPVUUQssiCatq/V/AfOdXwAqa0jh6bI
         u3+tvjzIdOcFSR7iF1+iCy5p69sUvupm20I3Cz+G6wGKD4QoTI6qVkAw+cbGHJ9IntsD
         ZJ1mJfj+4Lhs4I8J/MrjorFEqasen6hEqpgQp1bmlfwmXQCDSPi9K5hDZH5YVo/THSYE
         AspCEJM//TrJSonQiRtZRdeoARDTX1lPEDWozi22EVKpiimvkLfgfd7GH3DUPkG/8lrY
         kfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751297733; x=1751902533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbO9psxgk55oppNmRGWDGVoNc1FLKxrpCgi5quujmE0=;
        b=YwgXcqmzsT5SdYRcM9kAkkl/A4QId6xe4H+duQKShmZJzTHelahspC9r8wFZmsnhcz
         bd59YewfWBNTrsz875RV04708uUQK+ZiX/4U2EANfWx7ybv0Yk58kBp08CYhLSN6uPeK
         hUs2pgGYJKG2nsFvETuN1gSVx0/bxmxd1W8UhhuNI/R0Pq3Pfe8+lE5yLiJyD4WBQ17E
         o7d8rQFOFC5+OraC1ALsECBbnMcMkovb6kCGa4burQhrhq1g3qClxlAkxSkRGT3G96dQ
         XpP4MFfh4injPOMjwLBmjRpDsdJ8kfp8MOqzxhPV76WhV3X/8UNxtcBrLO1rB+WQReyh
         PYUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGCTHLBOjkQ2z6woVLFc/nfmZEhZkq2Z9dDysU/FZllZEBx8SP+/mnCNPs6rOAV6MaXEoxt+U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRzEkH2TLIAIHygIpDLMIZgwBPD1ccpxwyP6FS9QlPtz4B8dgP
	d4TGTFlMtyeTE5HWWaSgfalb6dbdlkX0hm67DPRDwRJ9NGdHM1X0d9F+iGmNscppUUTybLjpQ4C
	Io6SVCpD9+qhPT00VJBGBOyQhwvWz3O3HPgL03aLs
X-Gm-Gg: ASbGncuil1IlTbJNHA6jBQc1VYH66F6MSY2u96iMHRfjjdP1k5JI1UAPLWE7hVwbTus
	OpQ7CwdKqc+9eB1EAOWSyW/Ak7rq4l8yebGSS+GwOFcIDM/FQzqfyAeMBBNKEmYMegbBDLfQgXO
	cLHDX5/mBjYKrltUp3Gn8/CkunyW4wDSpIzTp00Yr13UxJDpiwiz1WnR5dVolchil/NEbmeUEpV
	16FqkgF8Q==
X-Google-Smtp-Source: AGHT+IHOX7kF7dn11PIYsXqc5Lvgd9CFgVl0JgQOIRErwaVxAn3VrCW+V5ML7ah9kVF847kUzTGbYaJQz6lAmBOdyCw=
X-Received: by 2002:a05:6e02:1a6c:b0:3dd:d664:7e0d with SMTP id
 e9e14a558f8ab-3df56d1d4famr6330985ab.25.1751297732904; Mon, 30 Jun 2025
 08:35:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org> <20250605-james-perf-feat_spe_eft-v3-6-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-6-71b0c9f98093@linaro.org>
From: Ian Rogers <irogers@google.com>
Date: Mon, 30 Jun 2025 08:35:20 -0700
X-Gm-Features: Ac12FXyUBSBjSl_fXOEDXQ0KnLnvxPP2kraYhFsM6cPyGu_cMbUCD4cbUl7FD2s
Message-ID: <CAP-5=fVZjqapNHhZ_Gro39JmJ-57nEun-SQhM_rd=MkQbx3GLA@mail.gmail.com>
Subject: Re: [PATCH v3 06/10] perf: Add perf_event_attr::config4
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
> Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
> packet using another 64-bits of event filtering control. As the existing
> perf_event_attr::configN fields are all used up for SPE PMU, an
> additional field is needed. Add a new 'config4' field.
>
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/uapi/linux/perf_event.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_ev=
ent.h
> index 78a362b80027..0d0ed85ad8cb 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
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
