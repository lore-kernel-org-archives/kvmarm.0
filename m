Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8F32D7DF6
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 13:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769778287; cv=pass; b=hcjU671SE6ofWs0YZiFJ0iQFIMtimyos+x4/JjJO8f3qdJriLdBfpDdljLNCTxgGizCBG4DxQMkuFce4l2rbNJ1SVwoNjQvcmAsK63RfBHpP+g4gKkpcnfLJ0uIHjhvVqYIU/XVIm0XmjXEsoInyZBw0iPEHpWF6f0g84/MzjVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769778287; c=relaxed/simple;
	bh=Vgw+YmuKFpt7Bzh/SMymEWSmB7AN7N/XXnxFtlTku44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=shShyI9wg+YARVCdOuUbj/9dAykdaWrkUy1kU0y/WsdDA2l3Xm1V4zGRyBWYniqXdhBZSGBUiIsO/NNoi1bwnGyhAl/g3qiF1aH4uDIZVj4VKUv64ArAMh5HU/TMiq5ZNrKyEFcqMj41K1rSJ4njS8wmwlSnbMAIeLgx92S86jk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fsZ5BHUR; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fsZ5BHUR"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8715a4d9fdso257740266b.0
        for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 05:04:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769778282; cv=none;
        d=google.com; s=arc-20240605;
        b=SmvLRWEIqeuh7JiTnAwg/Wll2ehoucaTmjhm6C4cNfRcLgTBQvWMZ/Jrbw+71rM9vz
         965f9Ji4e3Pd8mdTh+oq1LVC1gmWpPM//4EU6kAVMYk0zMt1R/082ffZOx2YWR9Bio6K
         UhFQWZ6pfZrw6hzA+YoUEff9JEsKKQ6LECQguJw3H86fgxTWqfALLSu3ydGmWNCTcCnz
         fJydRJbd/3ELsmwnnzBnOFjh5awUnWk3kSVbIrPZMvzuvytrYvFAlifEhD0u1PPdB+BU
         nZ5CjZ8OR9xNqC9BopaY4TG6xgcyXouS9LQfjwfGSqYj0ut6fuc7ggHp/jTSw6qTaNiF
         gC2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UBf8C/0xR74j04aOxcYP8T2S3+hA9h8u2VJdmYV9Spg=;
        fh=Pp8UP/9A05ZfLbd2nXUZENXyMkRDAHStzzfzwIc1dCE=;
        b=jFvpj+nw8MKEFVi8xdGaPqSAbVSvOeAF7+aFPk+5M7mC1pmIo5SK7nA+cotKIlv6FZ
         Zoe6aWjS9ihVkrnphT6ZpfIm4IHTRiZXwctG/7mkp4Vdn4QhEZ3QgVXih9i7DhStGT8r
         sWU8hJvO84ioHQroPKCcULXh1BqySMvyN0i60eowWcIGTjqFOwhaH9H7+IA3sbPjA3gB
         BtJgdL3y7xwkAqXEsVHAWgT5OM3SMHZmAriNt2j/I4YQhLHpLcOPuj9A9vIulQU+KLAR
         Hp6wPum1CQYjz0R84QN1pX/gEQKCZlAudcRQO9Uu4GYRaeGmJ98vjbbP8xGarJzQUDZ0
         +mUA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769778282; x=1770383082; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBf8C/0xR74j04aOxcYP8T2S3+hA9h8u2VJdmYV9Spg=;
        b=fsZ5BHURnSSbPoXvxOCRq57Zdme2Z3WnbC0GJ/W13UvTnurtqiYX3kqtbbDi7SfJvP
         DQ0GNg2whyPxNAI8+A7ZX075AipHMegR8zb/DUBX2ozzopMw1Wgauf2RfEqJQK7r3gf+
         dqZRCD7hK8F5SoUmw9QlmPuXlfLKljhbL5kI7M57AJHm0KSoLDJhDIY5F1Ar/rMKCLbJ
         C2y/Cfs63YRD5OHjSWFEZyh2RDU107LKBHwL2cjz1iogC35wHtcpLMLhvUvpKN2y9AyN
         Y/pLP9PYc/dq3HlfEQ1N4NmI06UTci1N2JYmQgepx2YB3UpMwK9leH9Cgn/CtUwBBuma
         8hIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769778282; x=1770383082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UBf8C/0xR74j04aOxcYP8T2S3+hA9h8u2VJdmYV9Spg=;
        b=u9mSU46E6ikZGFH1zgjg02HetEYsFgPrQ/SMPGSw6GoMHqdmhA8e7g11wO5mIWsnCf
         DzwZH2JWZYEt4OZ1hqrDA6Vq++u8/oC7Xt+xGRXm23tnfJsMilmbwrwfuAaKg/T4vVUg
         aIf3aJgaH4By8Z1W4zLtuJL5l0Io+f7IWs6Yu4tp806fgotNxgJvPlWEGE0A57LPuqnT
         gnaMgWW00W7FfMDCMei3/BQRiKPQ6LOWcaLjLxqygBGWUH+RigbK4/WFIEKxvXykkBfG
         /e5lTgWsQoB3e12lo6ut/PxmNu483/j18iJ0qxYGEgUpdJjhitDIh/uzGiX/SvrqW11v
         Jmzw==
X-Forwarded-Encrypted: i=1; AJvYcCU+ySXbRpq+meq9flCrWjGhIep1ilUe7E45n+sXFZrAa2elo8Z4SMWn5DkNqyOPYkSXKRPflYU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAge6VqUv4loCS2Z20QBw73Z68lv/j7f2Ji+ptXHwM/pvhrXQC
	2hW3bX6jDR6L5F25v2lk6vtkKCOCJYDOLB0NDP2T4eMm6Z7RNYd4MjB0UoBTTtD/ss2BJVCd4mV
	1D5ZYIni0CY2Yw2BzM4+bX7usokwbM0S80GECRzDV
X-Gm-Gg: AZuq6aL7ybXmQcbcTXF55BhxlN0gQuSqSnKpEgcf0KvEopFkcgdDzR3hC/VopuKCQCK
	2eWxuKd5yEYyjMS+7D7+R2yysHlP92ziM3y+4hU2q4k4BQ05uUEIhHGcOAdPTzWst2GWx+/7jBn
	XZvPLYLmIDnxyJRYrVJrgdMq6nNz+uTHkH9NsLVRlcPN5t/DQJIn96QrrPcRvrJ8wjPi7h/OSSP
	GNxa0weFNfaz+brTpwPUPxFN0+thq5Khzg88VpjZJoSUUifNj3LCRJrISCTTTxPQz4HGEd56tYr
	qVfOIVc6Q4b85V430KXZfRHtDhr0bpAXTg==
X-Received: by 2002:a17:907:704:b0:b88:3bb9:e2d1 with SMTP id
 a640c23a62f3a-b8dff8b1453mr142780166b.60.1769778281634; Fri, 30 Jan 2026
 05:04:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260112165914.4086692-1-ben.horgan@arm.com> <20260112165914.4086692-30-ben.horgan@arm.com>
 <CALPaoCh+mRLJEfhKBve3hRf+vHHoObjvWRt74OfpopgtR9g9FQ@mail.gmail.com>
 <c157d2b6-7282-438f-b9e7-1a24be3fbf53@arm.com> <CALPaoCi0fR5sUVsjXi25XHBrhn3whFvKDpEvUGSM5Hjd2LZP6w@mail.gmail.com>
 <2ce2b78e-9a79-489d-813c-3ed6ced34f12@arm.com>
In-Reply-To: <2ce2b78e-9a79-489d-813c-3ed6ced34f12@arm.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 30 Jan 2026 14:04:29 +0100
X-Gm-Features: AZwV_Qgsp2QKetSJZCBE6HG-t_3ZxRz8uwHEr5HdiTUFCwojXmkqXvN5_gENpCw
Message-ID: <CALPaoCgfi8qgJi_yijJ5u933faMvCZCjdBOGCKxOd4uqwEJhyw@mail.gmail.com>
Subject: Re: [PATCH v3 29/47] arm_mpam: resctrl: Pick classes for use as mbm counters
To: Ben Horgan <ben.horgan@arm.com>
Cc: James Morse <james.morse@arm.com>, amitsinght@marvell.com, baisheng.gao@unisoc.com, 
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com, 
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com, 
	fenghuay@nvidia.com, gshan@redhat.com, jonathan.cameron@huawei.com, 
	kobak@nvidia.com, lcherian@marvell.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, punit.agrawal@oss.qualcomm.com, 
	quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com, 
	scott@os.amperecomputing.com, sdonthineni@nvidia.com, 
	tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com, 
	will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Mon, Jan 26, 2026 at 5:00=E2=80=AFPM Ben Horgan <ben.horgan@arm.com> wro=
te:
>
> Hi Peter, James,
>
> On 1/19/26 12:47, Peter Newman wrote:
> > Hi James,
> >
> > On Mon, Jan 19, 2026 at 1:04=E2=80=AFPM James Morse <james.morse@arm.co=
m> wrote:
> >>
> >> Hi Peter,
> >>
> >> On 15/01/2026 15:49, Peter Newman wrote:
> >>> On Mon, Jan 12, 2026 at 6:02=E2=80=AFPM Ben Horgan <ben.horgan@arm.co=
m> wrote:
> >>>> From: James Morse <james.morse@arm.com>
> >>>>
> >>>> resctrl has two types of counters, NUMA-local and global. MPAM has o=
nly
> >>>> bandwidth counters, but the position of the MSC may mean it counts
> >>>> NUMA-local, or global traffic.
> >>>>
> >>>> But the topology information is not available.
> >>>>
> >>>> Apply a heuristic: the L2 or L3 supports bandwidth monitors, these a=
re
> >>>> probably NUMA-local. If the memory controller supports bandwidth mon=
itors,
> >>>> they are probably global.
> >>
> >>> Are remote memory accesses not cached? How do we know an MBWU monitor
> >>> residing on a cache won't count remote traffic?
> >>
> >> It will, yes you get double counting. Is forbidding both mbm_total and=
 mbm_local preferable?
> >>
> >> I think this comes from 'total' in mbm_total not really having the obv=
ious meaning of the
> >> word:
> >> If I have CPUs in NUMA-A and no memory controllers, then NUMA-B has no=
 CPUs, and all the
> >> memory-controllers.
> >> With MPAM: we've only got one bandwidth counter, it doesn't know where=
 the traffic goes
> >> after the MSC. mbm-local on the L3 would reflect all the bandwidth, an=
d mbm-total on the
> >> memory-controllers would have the  same number.
> >> I think on x86 mbm_local on the CPUs would read zero as zero traffic w=
ent to the 'local'
> >> memory controller, and mbm_total would reflect all the memory bandwidt=
h. (so 'total'
> >> really means 'other')
> >
> > Our software is going off the definition from the Intel SDM:
> >
> > "This event monitors the L3 external bandwidth satisfied by the local
> > memory. In most platforms that support this event, L3 requests are
> > likely serviced by a memory system with non-uniform memory
> > architecture. This allows bandwidth to off-package memory resources to
> > be tracked by subtracting local from total bandwidth (for instance,
> > bandwidth over QPI to a memory controller on another physical
> > processor could be tracked by subtraction).
>
> Indeed we should base our discussion on the event definition in the
> Intel SDM. For our reference, the description for the external bandwidth
> monitoring event (mbm_total) is:
>
> "This event monitors the L3 total external bandwidth to the next level
> of the cache hierarchy, including all demand and prefetch misses from
> the L3 to the next hierarchy of the memory system. In most platforms,
> this represents memory bandwidth."
>
> >
> > On NUMA-capable hardware that can support this event where all memory
> > is local, mbm_local =3D=3D mbm_total, but in practice you can't read th=
em
> > at the same time from userspace, so if you read mbm_total first,
> > you'll probably get a small negative result for remote bandwidth.
> >
> >>
> >> I think what MPAM is doing here is still useful as a system normally h=
as both CPUs and
> >> memory controllers in the NUMA nodes, and you can use this to spot a c=
ontrol/monitor group
> >> on a NUMA-node that is hammering all the memory (outlier mbm_local), o=
r the same where a
> >> NUMA-node's memory controller is getting hammered by all the NUMA node=
s (outlier
> >> mbm_total)
> >>
> >> I've not heard of a platform with both memory bandwidth monitors at L3=
 and the memory
> >> controller, so this may be a theoretical issue.
> >>
> >> Shall we only expose one of mbm-local/total to prevent this being seen=
 by user-space?
> >
> > I believe in the current software design, MPAM is only able to support
> > mbm_total, as an individual MSC (or class of MSCs with the same
> > configuration) can't separate traffic by destination, so it must be
> > the combined value. On a hardware design where MSCs were placed such
> > that one only counts local traffic and another only counts remote, the
> > resctrl MPAM driver would have to understand the hardware
> > configuration well enough to be able to produce counts following
> > Intel's definition of mbm_local and mbm_total.
>
> On a system with MSC measuring memory bandwidth on the L3 caches these
> MSC will measure all bandwidth to the next level of the memory hierarchy
> which matches the definition of mbm_total. (We assume any MSC on an L3
> is at the egress even though acpi/dt doesn't distinguish ingress and
> egress.)
>
> For MSC on memory controllers then they don't distinguish which L3 cache
> the traffic came from and so unless there is a single L3 then we can't
> use these memory bandwidth monitors as they count neither mbm_local nor
> mbm_total. When there is a single L3 (and no higher level caches) then
> it would match both mbm_total and mbm_local.

The text you quoted from Intel was in the context of the L3. I assume
if such an event were implemented at a different level of the memory
system, it would continue to refer to downstream bandwidth.

>
> Hence, I agree we should just use mbm_total and update the heuristics
> such that if the MSC are at the memory only consider them if there are
> no higher caches and a single L3.

That should be ok for now. If I see a system where this makes MBWU
counters inaccessible, we'll continue the discussion then.

>
> The introduction of ABMC muddies the waters as the "event_filter" file
> defines the meaning of mbm_local and mbm_total. In order to handle this
> file properly with MPAM, fs/resctrl changes are needed. We could either
> make "event_filter" show the bits that correspond to the mbm counter and
> unchangeable or decouple the "event_filter" part of ABMC from the
> counter assignment part. As more work is needed to not break abi here
> I'll drop the ABMC patches from the next respin of this series.

I would prefer if you can just leave out the event_filter or make it
unconfigurable on MPAM. The rest of the counter assignment seems to
work well.

Longer term, the event_filter interface is supposed to give us the
ability to define and name our own counter events, but we'll have to
find a way past the decision to define the event filters in terms
copy-pasted from an AMD manual.

Thanks,
-Peter
