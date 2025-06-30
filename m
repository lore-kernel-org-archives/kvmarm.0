Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8BB28C03D
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297928; cv=none; b=MguGrgbIx7Sq945vxrXMg6Db+9RiWxRebXdJnbBAy+1V1CaWbrGkK6ScSR8z5uxHhuTnr3TS7la7XqVUtDc4bg9WDan+zTUZM449mDKiw9edXFo5WLjsj+G1jR2Xz+LWxbBKnnJ97aSigVizsg8ndXDeNzOftt88dzcP+CBf6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297928; c=relaxed/simple;
	bh=YJtneUSRYE/YcZtnrONC52bBke/mflK3Z7IJ4jYkVv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AUzd8rJ9tIjMPBLvqYMrV/LkinyZsA7ZGkFTx6m31wzUUXV3V0i0JGstxlKKIHDSsa4Eig5dNkU1abXZsWt/YMPoJ2eNxzCxeDQsMvo4mLCY1yQWVR/vv1FR4Fkyy6s0TzxcRuKNkyVkFUB7bbxULBU8CcsqRRxC2RPaMvO3P10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UGiZMA/U; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UGiZMA/U"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ddc99e0b77so489335ab.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 08:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751297926; x=1751902726; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8pHTrUEcGe6WdpAUlyhQvIpo4p8iXNvnGE/h+atsss=;
        b=UGiZMA/UEbD9QrtJcMik2PksGHhGq1Dl6FKLasOkcY1nqTpSWSc/ufzBxV7cLsMtfd
         u06TiyuBKYAexYsLFNt9KSPqHnE1W0gOvz80nvS2a6F09q9UiJlgRtLR9+VrS14ik5P5
         +w2cz4YJ8tl/ruKkzfpQZ+o1/ay6fQ2k/69ipnk0XZ+HUP1DsQw07HJyNHUno+MT+aYY
         zWs/WVXBZZmFuhQACCDxusdNdN+VBHshVAog6QOxmC0GQ/sYcHU1OhCLW6GK1upISDHp
         G8sLmq8dn0Q36asDGchQd3gbREObMcaYXQVGFzJvceeja2AEDipKrvlrF/qQ20Zdyzh6
         /xCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751297926; x=1751902726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o8pHTrUEcGe6WdpAUlyhQvIpo4p8iXNvnGE/h+atsss=;
        b=eCFqkgqj+Bp+7rU2gH68N65IJEaIPTFuR4Q8cjlO4rueNDsLhFK8oTp+VjLZ+J2eRM
         lZXyZTObGT+oXHE21C6xQyZpsmAHDl7BseflMgpyAF7j3oKwoZMZjY4efIq2WFXfOXI5
         kkbla2ZQNKAMeR1dw6yStToc/Yogc+gFciX0DpZQDHXuVAydEbUG9xQ5bXg2ICXubKrR
         EnFWXcBENR7ZL+0d/ci8+lziVeJpnYxlicnsMhT/ora+xwjlhDvJ5TvUUYZuCmrmVOj/
         6ZmOBHDQrn10LtnWmIz6oqYxCNz7MeVCNHiwuYpsLji29RRomZcCD7es0l3benAnfX5G
         xgpA==
X-Forwarded-Encrypted: i=1; AJvYcCWzm6yHgJjCr3K5MSg0L2fiMY2XQ5t5J9lFEMEPFLdSSdMe72pdiw4LOx0cC1jt6GpDtAzARZY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrM+JZbudiyKxxUlzZhgRrJSvTZUfhbbjQKBI3gjfKbaWw2Ufw
	oe8xSUIx9r3mRuMLg2STq+enW0Jw7BAQKjDIpaLFK33X8ie0kwEBK3EiwAY+K0ZoQu7TLehQcqC
	Bfm+u7+slyGYVHfPB8Utt5LghZLSLSgNmFZrk0eGQ
X-Gm-Gg: ASbGncv4jDxUiXlcpnuLM4r7+GowrDPrmfqxFGD+hKmUOg7R30BhhalAoU7w2CM/y2e
	ZcGFwD4P0AyquWzWvnU0d81WXzx5n/VEcXirKpragbNTFfr+WetJCeBrzeXm8UaKRgtOgASjjyM
	Qv9DqUZnjt8QyCmcRqTz2+5aIoX4t+eKgxxAMw+z/rPBRP93ixg8q+ESYUWem3yQ55szYPlxqAu
	b+/8FTeJg==
X-Google-Smtp-Source: AGHT+IHWAVAMI8QT9eGJcy1Dz/MUqM4kKkgHbIFGRnRbpDP3mlZrGKmhK69cnZjnige15KSJimxL8+8uvBWPiDVJgMM=
X-Received: by 2002:a92:c265:0:b0:3dd:d288:eead with SMTP id
 e9e14a558f8ab-3df5587f1f2mr7193765ab.18.1751297925487; Mon, 30 Jun 2025
 08:38:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org> <20250605-james-perf-feat_spe_eft-v3-10-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-10-71b0c9f98093@linaro.org>
From: Ian Rogers <irogers@google.com>
Date: Mon, 30 Jun 2025 08:38:33 -0700
X-Gm-Features: Ac12FXz-XNRDh5SWs9KqIAss_dxekSdRnzTpiZe4QDr_HQFGVYwsbdMlOQVPWnw
Message-ID: <CAP-5=fU24cknDdD8Lxfshqei7Twf9zRA6uOrQNJqvAVyrzgi-g@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] perf docs: arm-spe: Document new SPE filtering features
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
> FEAT_SPE_EFT and FEAT_SPE_FDS etc have new user facing format attributes
> so document them. Also document existing 'event_filter' bits that were
> missing from the doc and the fact that latency values are stored in the
> weight field.
>
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/Documentation/perf-arm-spe.txt | 97 +++++++++++++++++++++++++=
+++---
>  1 file changed, 88 insertions(+), 9 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-arm-spe.txt b/tools/perf/Docum=
entation/perf-arm-spe.txt
> index 37afade4f1b2..4092b53b58d2 100644
> --- a/tools/perf/Documentation/perf-arm-spe.txt
> +++ b/tools/perf/Documentation/perf-arm-spe.txt
> @@ -141,27 +141,65 @@ Config parameters
>  These are placed between the // in the event and comma separated. For ex=
ample '-e
>  arm_spe/load_filter=3D1,min_latency=3D10/'
>
> -  branch_filter=3D1     - collect branches only (PMSFCR.B)
> -  event_filter=3D<mask> - filter on specific events (PMSEVFR) - see bitf=
ield description below
> +  event_filter=3D<mask> - logical AND filter on specific events (PMSEVFR=
) - see bitfield description below
> +  inv_event_filter=3D<mask> - logical OR to filter out specific events (=
PMSNEVFR, FEAT_SPEv1p2) - see bitfield description below
>    jitter=3D1            - use jitter to avoid resonance when sampling (P=
MSIRR.RND)
> -  load_filter=3D1       - collect loads only (PMSFCR.LD)
>    min_latency=3D<n>     - collect only samples with this latency or high=
er* (PMSLATFR)
>    pa_enable=3D1         - collect physical address (as well as VA) of lo=
ads/stores (PMSCR.PA) - requires privilege
>    pct_enable=3D1        - collect physical timestamp instead of virtual =
timestamp (PMSCR.PCT) - requires privilege
> -  store_filter=3D1      - collect stores only (PMSFCR.ST)
>    ts_enable=3D1         - enable timestamping with value of generic time=
r (PMSCR.TS)
>    discard=3D1           - enable SPE PMU events but don't collect sample=
 data - see 'Discard mode' (PMBLIMITR.FM =3D DISCARD)
> +  data_src_filter=3D<mask> - mask to filter from 0-63 possible data sour=
ces (PMSDSFR, FEAT_SPE_FDS) - See 'Data source filtering'
>
>  +++*+++ Latency is the total latency from the point at which sampling st=
arted on that instruction, rather
>  than only the execution latency.
>
> -Only some events can be filtered on; these include:
> -
> -  bit 1     - instruction retired (i.e. omit speculative instructions)
> +Only some events can be filtered on using 'event_filter' bits. The overa=
ll
> +filter is the logical AND of these bits, for example if bits 3 and 5 are=
 set
> +only samples that have both 'L1D cache refill' AND 'TLB walk' are record=
ed. When
> +FEAT_SPEv1p2 is implemented 'inv_event_filter' can also be used to exclu=
de
> +events that have any (OR) of the filter's bits set. For example setting =
bits 3
> +and 5 in 'inv_event_filter' will exclude any events that are either L1D =
cache
> +refill OR TLB walk. If the same bit is set in both filters it's UNPREDIC=
TABLE
> +whether the sample is included or excluded. Filter bits for both event_f=
ilter
> +and inv_event_filter are:
> +
> +  bit 1     - Instruction retired (i.e. omit speculative instructions)
> +  bit 2     - L1D access (FEAT_SPEv1p4)
>    bit 3     - L1D refill
> +  bit 4     - TLB access (FEAT_SPEv1p4)
>    bit 5     - TLB refill
> -  bit 7     - mispredict
> -  bit 11    - misaligned access
> +  bit 6     - Not taken event (FEAT_SPEv1p2)
> +  bit 7     - Mispredict
> +  bit 8     - Last level cache access (FEAT_SPEv1p4)
> +  bit 9     - Last level cache miss (FEAT_SPEv1p4)
> +  bit 10    - Remote access (FEAT_SPEv1p4)
> +  bit 11    - Misaligned access (FEAT_SPEv1p1)
> +  bit 12-15 - IMPLEMENTATION DEFINED events (when implemented)
> +  bit 16    - Transaction (FEAT_TME)
> +  bit 17    - Partial or empty SME or SVE predicate (FEAT_SPEv1p1)
> +  bit 18    - Empty SME or SVE predicate (FEAT_SPEv1p1)
> +  bit 19    - L2D access (FEAT_SPEv1p4)
> +  bit 20    - L2D miss (FEAT_SPEv1p4)
> +  bit 21    - Cache data modified (FEAT_SPEv1p4)
> +  bit 22    - Recently fetched (FEAT_SPEv1p4)
> +  bit 23    - Data snooped (FEAT_SPEv1p4)
> +  bit 24    - Streaming SVE mode event (when FEAT_SPE_SME is implemented=
), or
> +              IMPLEMENTATION DEFINED event 24 (when implemented, only ve=
rsions
> +              less than FEAT_SPEv1p4)
> +  bit 25    - SMCU or external coprocessor operation event when FEAT_SPE=
_SME is
> +              implemented, or IMPLEMENTATION DEFINED event 25 (when impl=
emented,
> +              only versions less than FEAT_SPEv1p4)
> +  bit 26-31 - IMPLEMENTATION DEFINED events (only versions less than FEA=
T_SPEv1p4)
> +  bit 48-63 - IMPLEMENTATION DEFINED events (when implemented)
> +
> +For IMPLEMENTATION DEFINED bits, refer to the CPU TRM if these bits are
> +implemented.
> +
> +The driver will reject events if requested filter bits require unimpleme=
nted SPE
> +versions, but will not reject filter bits for unimplemented IMPDEF bits =
or when
> +their related feature is not present (e.g. SME). For example, if FEAT_SP=
Ev1p2 is
> +not implemented, filtering on "Not taken event" (bit 6) will be rejected=
.
>
>  So to sample just retired instructions:
>
> @@ -171,6 +209,31 @@ or just mispredicted branches:
>
>    perf record -e arm_spe/event_filter=3D0x80/ -- ./mybench
>
> +When set, the following filters can be used to select samples that match=
 any of
> +the operation types (OR filtering). If only one is set then only samples=
 of that
> +type are collected:
> +
> +  branch_filter=3D1     - Collect branches (PMSFCR.B)
> +  load_filter=3D1       - Collect loads (PMSFCR.LD)
> +  store_filter=3D1      - Collect stores (PMSFCR.ST)
> +
> +When extended filtering is supported (FEAT_SPE_EFT), SIMD and float
> +pointer operations can also be selected:
> +
> +  simd_filter=3D1         - Collect SIMD loads, stores and operations (P=
MSFCR.SIMD)
> +  float_filter=3D1        - Collect floating point loads, stores and ope=
rations (PMSFCR.FP)
> +
> +When extended filtering is supported (FEAT_SPE_EFT), operation type filt=
ers can
> +be changed to AND using _mask fields. For example samples could be selec=
ted if
> +they are store AND SIMD by setting 'store_filter=3D1,simd_filter=3D1,
> +store_filter_mask=3D1,simd_filter_mask=3D1'. The new masks are as follow=
s:
> +
> +  branch_filter_mask=3D1  - Change branch filter behavior from OR to AND=
 (PMSFCR.Bm)
> +  load_filter_mask=3D1    - Change load filter behavior from OR to AND (=
PMSFCR.LDm)
> +  store_filter_mask=3D1   - Change store filter behavior from OR to AND =
(PMSFCR.STm)
> +  simd_filter_mask=3D1    - Change SIMD filter behavior from OR to AND (=
PMSFCR.SIMDm)
> +  float_filter_mask=3D1   - Change floating point filter behavior from O=
R to AND (PMSFCR.FPm)
> +
>  Viewing the data
>  ~~~~~~~~~~~~~~~~~
>
> @@ -204,6 +267,10 @@ Memory access details are also stored on the samples=
 and this can be viewed with
>
>    perf report --mem-mode
>
> +The latency value from the SPE sample is stored in the 'weight' field of=
 the
> +Perf samples and can be displayed in Perf script and report outputs by e=
nabling
> +its display from the command line.
> +
>  Common errors
>  ~~~~~~~~~~~~~
>
> @@ -247,6 +314,18 @@ to minimize output. Then run perf stat:
>    perf record -e arm_spe/discard/ -a -N -B --no-bpf-event -o - > /dev/nu=
ll &
>    perf stat -e SAMPLE_FEED_LD
>
> +Data source filtering
> +~~~~~~~~~~~~~~~~~~~~~
> +
> +When FEAT_SPE_FDS is present, 'data_src_filter' can be used as a mask to=
 filter
> +on a subset (0 - 63) of possible data source IDs. The full range of data=
 sources
> +is 0 - 65535 although these are unlikely to be used in practice. Data so=
urces
> +are IMPDEF so refer to the TRM for the mappings. Each bit N of the filte=
r maps
> +to data source N. The filter is an OR of all the bits, so for example se=
tting
> +bits 0 and 3 includes only packets from data sources 0 OR 3. When
> +'data_src_filter' is set to 0 data source filtering is disabled and all =
data
> +sources are included.
> +
>  SEE ALSO
>  --------
>
>
> --
> 2.34.1
>
