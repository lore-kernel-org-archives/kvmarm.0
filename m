Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E61A2DECA1
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 07:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781509443; cv=none; b=bdpL1lcqbqmujUANSB3T731CSB8l18DYd3dhHgGxWmHKGdbxPKTrRfMxZ/7nZsKcBRg0DDfjT2oQmO6Zbi4KjeXa4cOl2LoTL4mPZwWCxmdCjbgFT0dkWogVsKWESe+q94Ni2MjOf089ocy0zJyLql0olw8TsDrbOo0eJ0LlJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781509443; c=relaxed/simple;
	bh=YB7lqwAJSemwzzCmfInsR18dvX6vqF3gRDnCJUKI5uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwLJw3M4KLXSYQmIcZUBq7e9Z1M8VCM3deEAoyKbRQZYXfjNkVSQ6Xh1ZhwFg/qdC6k7IHpIpd9bZbzamfKUFbR2ggCaUQqr9R1n00UiMvSFgm2q4x25M+Xqg7rmq/NIhOEU17f1072/pZRvwRRn0M6KgurGzkhHBPL34JiQUO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRde1cS/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRde1cS/"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490bb5ad3bdso85445e9.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 00:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781509440; x=1782114240; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vx+Fcy9JfXnbV77ZN56f/2+W+MwbQKemGkhdPZhU9VU=;
        b=pRde1cS/HG5V0kt4cjbmuOI0003SERNB/U/pXDYmVApTbevhvID+iKzPW4y1u/GA5w
         aGm0tE7nDhoiu0u8v0KERmbllrKLxoD6LQSJ6AlKQP2LyYy7rYN3i6M29TTNQIEBJODY
         bIENKhsB1ZyZOqqamgt0qO2HWbrsTn0Q7cFLuXHVkbiXtCDbXYcgxF/k0rYRGmwFtELN
         cYZPXd+dGH5uU9663LnQRD04YZ2oyDqn/5eUneBRA6U07ZQ+Toyfs/5dtfIrlbyf+Xyf
         1K9VeBPBVJi4mbZ3CAAKkbkvZlduYfgsZMpxFOWF2k0f68UyqiIx8B4beuTacsFg+i4s
         2c0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781509440; x=1782114240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vx+Fcy9JfXnbV77ZN56f/2+W+MwbQKemGkhdPZhU9VU=;
        b=OsWotMIjNxUx3fGWYJFkl69GuSxUlia7pqMZNWx8G8QHaikaIxXBIUIY5y84Bb0rrW
         1PC7/mDqV4NVq+LE/j44URAImFBt3GBqiiId3xvVNNBtwV7JvFXUyidHNzouzvzoV+rl
         TQeYLLNSw853rbqhbo7tGz0tue+itM+imGY9W32izYaYNQChpfvugYezSiaZzezlF8Pd
         fYCnruwiNs2tl1M8WKTfFaj3t6Hy6mnNvhAfIVH9zF3DAIlkU/l6B14hr+LKC+t+8JDO
         59cygm7uDrmuYTJFDf4CsTgnvkxLgEjCysGWcnzewC9Xi6ugD+PwUdI5wCJGU/dsF9TE
         Yh6g==
X-Forwarded-Encrypted: i=1; AFNElJ/mXLnU7vHFVt3gr2227maVEzyCpXMNStNaQroK1Ky0/OnDnBPeaM+B2myaJ2Gqfkod6/rISiU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPYNz50wS1hFl3U2YZzSDYkx7UdIN2p9PZDXov+IYm3SIru654
	/1PxPLibsAfVJx6be87s2s3/T6cbV00QhC0Vnaa3SjSK2vjrgyY4kYhlW+ENWEOdpQ==
X-Gm-Gg: Acq92OEB1BfWGRytL47n1xOVZra16Vynw7GB1XNC8S6ZujhZZhImYA5zQwjetX3cXhX
	/ZVSYLMS/dcWPi3L4mOWzUCIUpmzLsHLJQCbdW3+qZxj+qOFC3SglsB9MiNC3uN20OP5Q9ywLdl
	BZcndLSUWsF1QWpLtvuP4UzM+wFrDOkLltyqiZsmi6KfS0lslj/InODKxn1tSNIufJWkYUC6+aR
	1SvsdD0k4kXftLEfqu3mgnJY0teVMQjUGwkLVJdeMJ3d9R5dhjjoTB4WcSBSAiJA/1cSwnncY36
	osaSUgAEwiiUgiENyQmM11/OCVCWEss6952zbeblMjA2IH6uPRgROyVm8aseDbYkkldCC9PxWfZ
	OJ8yEvWL/oEK7qlvjud8ek0UHAN5aveQb1cifmwVVSuGgkbNs1pLp9Ro97I5etpxCfTDFWVWOwp
	EYBOBjuLZ5znQN2wrFrO/89+zbAUmMAeAfh8Gkw/R0Od159E+aFWlk5EL5hcqeO+GYNSIigA==
X-Received: by 2002:a05:600c:c05a:b0:489:1ace:d0d3 with SMTP id 5b1f17b1804b1-49221849ad5mr2294065e9.3.1781509439578;
        Mon, 15 Jun 2026 00:43:59 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95b274sm318590355e9.1.2026.06.15.00.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 00:43:59 -0700 (PDT)
Date: Mon, 15 Jun 2026 07:43:55 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ai-tO-sSNGp7mjAU@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
 <ailVcN-bxY30-XBF@google.com>
 <ailXKA1VG8vyKNfV@willie-the-truck>
 <ailtCAcEaJIgZ5Ap@google.com>
 <ai50fgNHGUqz0muP@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai50fgNHGUqz0muP@willie-the-truck>

On Sun, Jun 14, 2026 at 10:29:34AM +0100, Will Deacon wrote:
> On Wed, Jun 10, 2026 at 02:56:24PM +0100, Vincent Donnefort wrote:
> > On Wed, Jun 10, 2026 at 01:23:04PM +0100, Will Deacon wrote:
> > > On Wed, Jun 10, 2026 at 01:15:44PM +0100, Vincent Donnefort wrote:
> > > > On Wed, Jun 10, 2026 at 11:15:14AM +0100, Will Deacon wrote:
> > > > > On Wed, Jun 10, 2026 at 10:26:59AM +0100, Vincent Donnefort wrote:
> > > > > > On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> > > > > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > > > > communicate with the secure services.
> > > > > > > While these calls are markes as optional, there is no reason why the
> > > > > > > hypervisor proxy would block them because:
> > > > > > > 
> > > > > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > > > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > > > > >    Because all forwarded notifications are inherently attributed to
> > > > > > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > > > > > >    originating from the Normal World.
> > > > > > > 
> > > > > > > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> > > > > > >    operate strictly via register-based parameters, passing only
> > > > > > >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> > > > > > >    not contain memory addresses, offsets, or pointers, forwarding
> > > > > > >    them doesn't pose a risk of memory-based confused deputy attack
> > > > > > >    (e.g., tricking the SPMC into overwriting protected memory).
> > > > > > > 
> > > > > > > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > > > > > > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > > > > > > flow is covered by the spec in the: '10.9 Notification support without
> > > > > > > a Hypervisor'.
> > > > > > 
> > > > > > As it is only a relayer. Is it really important to check SBZ arguments and
> > > > > > fields on behalf of Trustzone? It doesn't feel it brings any security. If the
> > > > > > host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 
> > > > > 
> > > > > I think the problem would be if an update to FF-A allocated some of the
> > > > > currently SBZ bits to implement some functionality that we would want
> > > > > to filter at EL2.
> > > > 
> > > > I suppose that would bump the FF-A version and the proxy would reject it?
> > > 
> > > Maybe? I don't think they'd _have_ to bump the version number.
> > > 
> > > > If we really want to check for those arguments to be 0:
> > > > 
> > > >  * Shouldn't we extend this check to other FF-A invocations?
> > > 
> > > yes, that's what the diff was doing in the reply here:
> > > 
> > > https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
> > > 
> > > but, as I said here:
> > > 
> > > https://lore.kernel.org/all/ahmxiFXXTupafbXw@willie-the-truck/
> > > 
> > > I don't particularly like the table-driven indirection (the checks
> > > should just be inlined).
> > 
> > Ha, sorry I'm late to the party. 
> > 
> > Perhaps this series should start with adding ffa_check_unused_args_sbz() to the
> > existing allowed FF-A invocations?

Hi Will,

> 
> Yes, that part now seems to be missing.

I am a bit worried to apply for all of them the check from the relayer
(ffa_check_unused_args_sbz) because of how it's written in the spec in
(11.2 Reserved parameter convention). To be more specific, there is no
mention of what the relayer is expected to do here (which is what hyp
does). It says 2 things:
1. the caller (in this case the host driver) is expected to zero out
unused args
2. the callee (Trustzone) ignores the values in these registers.

If we enforce SBZ in the relayer but (1) doesn't comply with it, we will
introduce a regression. I left it on purpose without enforcing
ffa_check_unused_args_sbz for the others.

> 
> Seb, please can you respin with that included?
> 
> Will

Thanks,
Sebastian
