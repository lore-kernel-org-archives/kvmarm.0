Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2835F8D2
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826888; cv=pass; b=tdds7n7tGauUhsbM+JzjTZ+1HaILfDx3ipVJIrXYyDhFOy5UhekVCkgFvZDgBPA3598Ir9ymxpW3yr0iXdE8V60bg876GqM+3MCkcS7bB/0+g5zm6ZFLZ4CRL/rZ21nuniElBUC+uZnWrkqaWWXAc5l7k2hQuOxnWp+0pPmQ1H0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826888; c=relaxed/simple;
	bh=kQHpNwAOUKHPYMoA/Ux1hVpdJHc11cXbz0W7Aqrta0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdi84sXpQd4ZiIQ3F3mC1kdy2rC1aJTqrIj3KO5NKJ3HPoidzEDrDCk9siwSWr5xgjuV2WUQYc1PQHtrtafr+Qy3SL9FkMQwyPU+QGnzsZrpV6V7BM+Q4UZCwo2yCOAusfTusU7X7AkQyA+pb74YxwvPfbtj9gwdn7k1NEICHwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UWI0VLVe; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UWI0VLVe"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so992081866b.2
        for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 04:48:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768826885; cv=none;
        d=google.com; s=arc-20240605;
        b=IPFuFZ8nGl3MDj4KDsQSm4D7TTMZ8wLmZH92lYI8Cxp3BiFtTmaw5d8vR4x41o6sak
         K6ZVFtN8QaPgyU3x8oXb7s1nlEYoM5Ds4cO3FOGw5DT8luGT/cjAI6zUT9awuscpquDE
         sRWz/cuibuqfEtA47RkNXDWHZMSnomgClWMl3l9MC9LoDq0BzDiUlJc0DOWt0Jqj85tA
         innL4D4vo9YVzbrMYoyH9ytQLZWwvrzGzYYT/SuzK9OJwkGS7T/ZqIk7I21+lTA/g3I8
         NzQCWnfqUG4Kh3AkHN0UC4QrJ+yvqqnhSrGN5UkDxFTDSVExB7xhY98CHEefrelYqVTF
         Z+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dXrxi/sUt3m+ih60Bf8tH6DyGI8ZFaGSjWDzM7R/mGQ=;
        fh=f+QNdRojIybo70HNFxmM6ucnrMt5hWhZ5Euh9+yVHTc=;
        b=aQJjfavJ4z5rMER83iGFzZrcdWEddOZPNy7X/yNe/wB0NFYTREhYKIE1IGZKjOcCAv
         X6YolHRIGEH7pSRpFy66PdBBM1dHTQOl4HeqbNzu8Z4gvxmKJiYY4JFLLl633BY+I5PC
         hIldegybP1yAU2vnKH8dD5GQ3ToBymkxLyB1V2K1WahBkoUhbzXjOnrdtP88ERuk1bvS
         qPwuAX4xD81oVPT+OoSnBnMDHAMS6mzdH9V4GbLyg+Hy3/IQf729nSpXvdDPj8N/oFoH
         edRe9j0RKvpucScug3T3+qus2xAlpyG2ApdKiXFLnav8x75wpGSqzjCSCZ2rCtfgy51M
         5G5g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768826885; x=1769431685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXrxi/sUt3m+ih60Bf8tH6DyGI8ZFaGSjWDzM7R/mGQ=;
        b=UWI0VLVefwlo8ylrQbeSsTz9RTHZf8mkVfK4M5D6gdGlI7nOqqRLoucjUJ3eD042Au
         t8YHtki9xA5GKorOC2xzecayr4UC9ZUZMlenFIXVvZ/ZTCl5nk/SzRmVma5z/YmrzFkt
         DK8Ej8ePwMoGQ9IXqTMrddg7AgXNRpWfZNligqdoePqlB51sjXY5sPihinxagYy+HbC/
         O238fCP5QtxjFbUbYGDgAR2v1rAcLyqfUryMZvi7fKa0+OJ9naGQC4qg7Kelx+ev5xzg
         LHs5DH8pbNpV0M5I/bM+2JS6gHrpYjerfuuzOf+w4wXjd3Rv36Kw9zvs93SNgOC3zbUi
         XoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768826885; x=1769431685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dXrxi/sUt3m+ih60Bf8tH6DyGI8ZFaGSjWDzM7R/mGQ=;
        b=ugiHh2nQFNCvq3YPCkQqDwS1jy7N2eMp6xWi0hbQt3e5cB8r6ha4gY//XDBq6QN3k5
         VNDzJpFnOKjhaXiiuU/2B9qRCsyj/lx41EXlsaZSEoXRsybjQt4LPxIWrizPmJNIxpCd
         s6NDFlRpSWSCllDnJk2zgFy8o0agdezHmHuZNjNvYHa/h5LLjlIDpQPaNRSleHf+/8N4
         qkjhvw2ZgT4IsDKxZnHXboyQw+kHidzyDeH8xVQhyf0og8GzQDDut980MR7ffYcqE15V
         cTor8dB8dmC0gO4zEcXSbT40ZEWGhNPlnwRSQUTMpjVv9pghNHllkPSxzo8Ns8x9e1DX
         hXgA==
X-Forwarded-Encrypted: i=1; AJvYcCXeF9BZATzSp2IA+gOUsa4Nun7d9hTwgmT4wB2PHEHEnTWXyQr/Kkh+bETpHmoOsuRhzpS34m0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjKV+NzE8MEiL+rfvL+9FbyJTMo26hfdwzbP8MgPAg2lSiAd7O
	2whxXdBLNJPkefb/HCDOGFrgv8Hr/o6sDdwAt+9rccbmlPd7hg/kvSjwZdX2qdk2GGMVG0Zo4TN
	3yPY+SW1IDhXPT6HG89bVMu9GSQd5f4J54dbjJ4Sf
X-Gm-Gg: AY/fxX41tWIKo3CvuWkrf0fOyrP/KU6g5M5xwERhAyGYOdtNrJi+RK4e/tQB7huewvr
	/EyKmmWGgRcxA4dN/tCi1ajWQ9fsFg5JjpozrX5P6XDO6aA6pcjNcf3T5O25QuzstXOUc6JMiJb
	6klLrRabgg4VhdLFhNGfWZZ6J5koXiR09QzIRpu7c9V9gY8+yycScoYzF2UAbtKBFBw0Jp22mv2
	ACE7d6kShVVMXQWZ3xpZh2SqdWTDb3bVgfXdV5dB43R/ECLq8O4OWeXweIAT4R1Pet4KjDLmh+5
	BZuGlZd/u2dpanxSBsAYk5hxgKh7edRBn1id+9fOzzKxMQo=
X-Received: by 2002:a17:907:3f8a:b0:b87:7485:b4a8 with SMTP id
 a640c23a62f3a-b8792b3c4e1mr857024566b.0.1768826884302; Mon, 19 Jan 2026
 04:48:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260112165914.4086692-1-ben.horgan@arm.com> <20260112165914.4086692-30-ben.horgan@arm.com>
 <CALPaoCh+mRLJEfhKBve3hRf+vHHoObjvWRt74OfpopgtR9g9FQ@mail.gmail.com> <c157d2b6-7282-438f-b9e7-1a24be3fbf53@arm.com>
In-Reply-To: <c157d2b6-7282-438f-b9e7-1a24be3fbf53@arm.com>
From: Peter Newman <peternewman@google.com>
Date: Mon, 19 Jan 2026 13:47:52 +0100
X-Gm-Features: AZwV_QiZJBdvmI194c6LN0fqut2vJhOeVYj5jDyWBOT_GKG0XUzMZqV82Gtifu8
Message-ID: <CALPaoCi0fR5sUVsjXi25XHBrhn3whFvKDpEvUGSM5Hjd2LZP6w@mail.gmail.com>
Subject: Re: [PATCH v3 29/47] arm_mpam: resctrl: Pick classes for use as mbm counters
To: James Morse <james.morse@arm.com>
Cc: Ben Horgan <ben.horgan@arm.com>, amitsinght@marvell.com, baisheng.gao@unisoc.com, 
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

Hi James,

On Mon, Jan 19, 2026 at 1:04=E2=80=AFPM James Morse <james.morse@arm.com> w=
rote:
>
> Hi Peter,
>
> On 15/01/2026 15:49, Peter Newman wrote:
> > On Mon, Jan 12, 2026 at 6:02=E2=80=AFPM Ben Horgan <ben.horgan@arm.com>=
 wrote:
> >> From: James Morse <james.morse@arm.com>
> >>
> >> resctrl has two types of counters, NUMA-local and global. MPAM has onl=
y
> >> bandwidth counters, but the position of the MSC may mean it counts
> >> NUMA-local, or global traffic.
> >>
> >> But the topology information is not available.
> >>
> >> Apply a heuristic: the L2 or L3 supports bandwidth monitors, these are
> >> probably NUMA-local. If the memory controller supports bandwidth monit=
ors,
> >> they are probably global.
>
> > Are remote memory accesses not cached? How do we know an MBWU monitor
> > residing on a cache won't count remote traffic?
>
> It will, yes you get double counting. Is forbidding both mbm_total and mb=
m_local preferable?
>
> I think this comes from 'total' in mbm_total not really having the obviou=
s meaning of the
> word:
> If I have CPUs in NUMA-A and no memory controllers, then NUMA-B has no CP=
Us, and all the
> memory-controllers.
> With MPAM: we've only got one bandwidth counter, it doesn't know where th=
e traffic goes
> after the MSC. mbm-local on the L3 would reflect all the bandwidth, and m=
bm-total on the
> memory-controllers would have the  same number.
> I think on x86 mbm_local on the CPUs would read zero as zero traffic went=
 to the 'local'
> memory controller, and mbm_total would reflect all the memory bandwidth. =
(so 'total'
> really means 'other')

Our software is going off the definition from the Intel SDM:

"This event monitors the L3 external bandwidth satisfied by the local
memory. In most platforms that support this event, L3 requests are
likely serviced by a memory system with non-uniform memory
architecture. This allows bandwidth to off-package memory resources to
be tracked by subtracting local from total bandwidth (for instance,
bandwidth over QPI to a memory controller on another physical
processor could be tracked by subtraction).

On NUMA-capable hardware that can support this event where all memory
is local, mbm_local =3D=3D mbm_total, but in practice you can't read them
at the same time from userspace, so if you read mbm_total first,
you'll probably get a small negative result for remote bandwidth.

>
> I think what MPAM is doing here is still useful as a system normally has =
both CPUs and
> memory controllers in the NUMA nodes, and you can use this to spot a cont=
rol/monitor group
> on a NUMA-node that is hammering all the memory (outlier mbm_local), or t=
he same where a
> NUMA-node's memory controller is getting hammered by all the NUMA nodes (=
outlier
> mbm_total)
>
> I've not heard of a platform with both memory bandwidth monitors at L3 an=
d the memory
> controller, so this may be a theoretical issue.
>
> Shall we only expose one of mbm-local/total to prevent this being seen by=
 user-space?

I believe in the current software design, MPAM is only able to support
mbm_total, as an individual MSC (or class of MSCs with the same
configuration) can't separate traffic by destination, so it must be
the combined value. On a hardware design where MSCs were placed such
that one only counts local traffic and another only counts remote, the
resctrl MPAM driver would have to understand the hardware
configuration well enough to be able to produce counts following
Intel's definition of mbm_local and mbm_total.

Thanks,
-Peter
