Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A28E3FD14F
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396124; cv=none; b=iYd5eo0uof2N5m+WIzdQga/fFWAOdt9JqgN8w3Dv+aO5viCzeHSNoZ4Ubc1FvwMQkbz0z2QTFQfw+SBv81mTz8/47lyGhmc5Fkx3ZBh2jsHmSgP67wqt17aJ1Cpbbkcsbg67eybW/Hj43CYQDEo5+g75lzSKslLTcLTXVreW0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396124; c=relaxed/simple;
	bh=CvmNfEBAQ89tGOMK7DQaeSfQgbqSiZwv8fzSb0HT698=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wh8+2pMmrwSFLWpFM9hnsBvAGbYv9Ekq+EhoG094JLrO33zT6Btkr60OWQzIPO5uGzA2TTL7f+Ls8T7XXFs9QGc1NQ6G+uStsZIAFqB8S7mFwEB9WDChLLfadfQsFY+3CR+AAWOPbMeYf/FD2gWGkCS59+3fsFmSIaYCXXnM0Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q+sm65BY; arc=none smtp.client-ip=91.218.175.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q+sm65BY"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CvmNfEBAQ89tGOMK7DQaeSfQgbqSiZwv8fzSb0HT698=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789396118; v=1; x=1790000918;
 b=Q+sm65BYCpGooXscDYjdG5dewdkLl3IVXoXuTcHtVzQF3PsawESAUc5fF046qkEJylKsyBzH
 CntQqKTblmLzHRfji0AYUDhliPTc37dKxwutd/H297bgRfCANIP2iiw+MDx9mYOmURz1hVH7zqI
 vbhBg6giZCN72XK+ZO4ohvO8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ad2d359a31b87417;
	Mon, 14 Sep 2026 14:28:38 +0000
X-Mizu-Trace-ID: ad2d359a31b87417
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so8520e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:28:35 -0700 (PDT)
X-Gm-Message-State: AFuF++klM3veTHncnOYQiJb1EqdSFuzgYr1eEy0/mNUa99fpcKtZwYgU
	W7ZRCL7yK0eG+ge2L2Blcz5K+azq5vQth+C1qVKvE8yfUuaUbZq/zFuTF1igG9nvQuEQD6cSoME
	kEQCwf9RUJsmekDAvewRQ6+58KoeQ5UxUal4fyEN8
X-Received: by 2002:a05:6512:118a:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b8af7bc5c0mr71769e87.15.1789396114627; Mon, 14 Sep 2026
 07:28:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-7-fuad.tabba@linux.dev>
 <20260914134258.9A5B21F000FF@smtp.kernel.org>
In-Reply-To: <20260914134258.9A5B21F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 15:27:57 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzGLLQCDgtiFnmSaLa+FaCXe9mpV8Dv=YQFSTgzZJOKng@mail.gmail.com>
X-Gm-Features: AcwNN1Uf6gkXjrF04VkdmyLvncwzRoQVaTVrUEmF0X0QpCHkyW8BHKoHTdDRSes
Message-ID: <CA+EHjTzGLLQCDgtiFnmSaLa+FaCXe9mpV8Dv=YQFSTgzZJOKng@mail.gmail.com>
Subject: Re: [PATCH v3 06/18] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Sept 2026 at 14:43, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Early return in `flush_debug_state` leaves the protected guest's `debug_owner` as `VCPU_DEBUG_FREE`, completely bypassing hardware debug register context switching and exposing host physical debug registers to the guest.

Same finding as on v2, same answer.

[...]
> [Severity: Critical]
> Does this early return leave the protected guest's debug_owner as
> VCPU_DEBUG_FREE (its zero-initialized value) instead of synchronizing it?
> This could bypass hardware debug register context switching, potentially
> exposing host physical debug registers to the guest.
[...]
> [Severity: Critical]
> By moving the mdcr_el2 copy into the non-protected branch, does the protected
> guest retain the EL2-computed mdcr_el2 where TDA is deliberately cleared?

The EL2-computed mdcr_el2 has TDA and TDRA set: a protected VM's
DebugVer is NI, so pvm_init_traps_mdcr() sets both and the guest's
debug register accesses trap. Keeping that value rather than the
host's is what this patch is for.

/fuad
