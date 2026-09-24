Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B814BA1D0;
	Thu, 24 Sep 2026 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272281; cv=none; b=HXH1/AD4tiwyA12XqQ6erNzegHldMFUuCK4OcRLiwmltkQGtk7Ld9/aXlF0DLO/LmSViVCamf/R5EupEYdZUslgfNR48qiMxU0Aj/FwsitBFTnClLvFLCSkz94/3Z0GXbKD8+044albvI7kxmksNxSVaGAlqYHrdkdr7rtU1YcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272281; c=relaxed/simple;
	bh=tUIUjE96mHX1ub0WJit1ydXJhlwhOvhdX23dKj5Bbbk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AjI716HRK7Wy4gbd9V13QDJRhgx6ZClHbFmaDzQW6zWIhC5BO7ddSp+aXxnQShBH7sfDjmpmrjwn7gXw7dg2eVnMRD2XTjjtDAIABcxmxhWLQs5NpTs+OkwW/e7nnIV2MBr9cXd/f2+hNXT36ONJTY8scumlB+LHKgi05nJWPqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrMRDYdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrMRDYdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30DF1F00898;
	Thu, 24 Sep 2026 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272279;
	bh=tUIUjE96mHX1ub0WJit1ydXJhlwhOvhdX23dKj5Bbbk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FrMRDYdYe7aQyjfb6k97UHWTB5fBlGZ9YnU9PtC/M5sNlzLWZof8xtVS8p+BVKf46
	 pKB4Sw+VD25QUeVR3n0dtrU9FZytWc0OUJlV3IESiNWLNICbCUMcwMRFq7++apzSBn
	 tybJQPLJAbJZbCQaOqAcWBgeM+G9aCPdQZCf7Wc4JuewewjvbK+xaD1t9acLrqqXEP
	 TvGTm7xwsxkjbbuSlt8jufROlUPgCB2xWcXRwu+Hb5VFgI3l8zU8DJ2lVnD7grZtnv
	 FCpZ7jgyCVK8Dh5AGM0/EZIGXkAdTWjjBhKPAIMqByHtAwCXK530iIqBnGxaUSv4MP
	 YxgwQ2PsQGMfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 15/22] KVM: arm64: Allow kvm_vcpu_pmu_resync_el0() to
 resync filters in process context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260924172928.2110956-16-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-16-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:51:18 +0000
Message-Id: <20260924175118.F30DF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Previously, kvm_vcpu_pmu_resync_el0() only scheduled
> KVM_REQ_RESYNC_PMU_EL0 when called from interrupt context (such as an
> IPI reprogramming host perf events). When perf_pmu_resched_update() is
> invoked synchronously from process context during vCPU load/put to
> reschedule host events around guest-reserved counters,
> armv8pmu_enable_event() calls kvm_set_pmu_events() and
> kvm_vcpu_pmu_resync_el0() in process context.
>=20
> Update kvm_vcpu_pmu_resync_el0() to call kvm_vcpu_pmu_restore_guest()
> directly when not in interrupt context so that newly rescheduled host
> perf events have their EL0 exclusion filters applied immediately.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D15

