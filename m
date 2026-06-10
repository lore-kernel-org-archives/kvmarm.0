Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE5240680A
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 12:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781093752; cv=none; b=enursM9o/9qpgoaRuJw0jyIi+o2BXA76W3zk8lm74L1TVTZNnurKQms11P6vEjt3zPH87FvejtFCzvnPO7MUIpSBJZuLqoVebOiGq2bo7IKzYdq/SKLZEUc04hdiLVdO0upBVcA2tz2nNe2SSZuRFpEMqxAxYAsREY+TVyIsPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781093752; c=relaxed/simple;
	bh=EQ4ylpXWi+YuFiR5Looby0OijETsTIL2XaXtihxgnN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sg5EI4uWqM2zuN86fSTm/k9NfuU/HMQePis3UfPRoa+xz3nggXrSgiwIwxjZjZgU0B++ppQgameGUyd9Uv8SoUTa0VGuNHcxRZzErqVhQBN0v9KYPssmn70derFk06AL5eE6pnprIw+pO/6l5aeorj39JOJHNhskoqoauOXhi1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UkTAIE/x; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkTAIE/x"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bf1cdcfd6deso821216266b.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 05:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781093749; x=1781698549; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bzJL0f8wCrWQURXF71Dj93R+/8RnEeuOYo8zI8bSgbE=;
        b=UkTAIE/xXD1lzjAtiaJDtDgGT7yTNlZDYtgVJztgK0dNIzujJJwmQcVaQiYczP8rEB
         ipXxAeY2SC3l/Cilikjwt0pvGGcBvbJqE5dNucfbNNf46Ub7qKe+BCkh4axy4U3zT2XZ
         BKlNAL9dYqxgnDDkcebGR5iECz9zBilwpS0fP9h9OcsuWbksnlAyb/9PNkoPlOVrvsOL
         KOIgVHTF0qoR4GkMNe6TciOl7JkBUFJjjqS5WMg0fHdvaeFza66VFTMbIwUooVD3Z7Vo
         EcTjYEziRhvUkoQGOpSS43pJTEE9O6VIKvhG/QqRflBxfEcm77GsnhO862AaRT0rVTuu
         E64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781093749; x=1781698549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzJL0f8wCrWQURXF71Dj93R+/8RnEeuOYo8zI8bSgbE=;
        b=YIN7+UpRecezyh6ENpErJX92N0eTsHopLMcaYW82mK602rrXBcDdSVMLhaLOx3pq8T
         OlS2Gx05HDJXlvInmxaQ/g7QRw2TYepZ8A+llEQy2ZQCLX3IPGA8jcRyaaXDsqJymsBq
         R8EFghO2E8ToNCr2qpjHdUjNxKzjFMhlxgIYQ3LLPe8s8ERXkJZb9E11DiwM6Od68aGS
         gRPbtYfAoblqGG6IfkalydBaiphEg3izyh25TNrpMt45pFKyoWYAgU+ni4s+kAwuLqmb
         5x1D+tCvgID4IhPfsd367IE3iPWBlewkKl/42J0yASJYHxXECpvLNOgqTpjmt/0MbKGs
         U3ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+itXK14Klels7yg1Ve/fUnaIK8+xFcCmbCjg2V8Hh9phx6zY1gqxZaN+3zNRxwIBLV3vdCWM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzamGFh1m2Yq9TF91BkZ5kBr2/PKJfuCz6E/Ml0ZyRlk+MVuTJw
	FG3y4aoBc0v3sNy3VKbGSGj0AuNLaAbElFw0Bho9UNBpaorR2utnPIuyc4Tqw2sq7A==
X-Gm-Gg: Acq92OE4KKthuRZQhlghhIZOGv3+rZV4sGnPMKEW/UKCMbxcxM4WGDUogfLberWvssp
	sJ3576x6pL+2VAFLe+laXgIap03Px423b251Dv6PnqWVN0RXo52ILF9OSz8xjCUSG87x29hq+89
	8yU4KDq/YOwWavs3H9E4raqSkCJmuj2If8GJjSxz/PtRymENf8rSXAEVKrlZYfweevZORl0ieBQ
	kZ6F2Wbo4QdC418Ah69+3OW9TApdK8MYZStGW1kkm/CvAmcqTSnhLOURRNWbocAML20m4UMyo01
	P/K/txygu3TL2fs27h74/sZ7KOkhSLB+Do7LBN89ilhcJzoROjDNBwv52zrHrWwXkXy3LQK54J7
	yfvwUYvhY/4Nq0r6Wb5Q00Y8lsSogptNoFmPV0funz7oVF1TycLF0wti8Eo8ROhFPH9QdutetMI
	1iwwHhIoAyRQmPuLRbIcGZBquyZ9HBgguNN9szB66Ee6cSxLkw/8tii4bqb3HQa2xTVpkRAdGcR
	tyoDw==
X-Received: by 2002:a17:907:267b:b0:bec:bd4f:e495 with SMTP id a640c23a62f3a-bf37155192bmr921560466b.12.1781093748467;
        Wed, 10 Jun 2026 05:15:48 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0559f1464sm1197120266b.55.2026.06.10.05.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 05:15:47 -0700 (PDT)
Date: Wed, 10 Jun 2026 13:15:44 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ailVcN-bxY30-XBF@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aik5MtvOlnQDmzjr@willie-the-truck>

On Wed, Jun 10, 2026 at 11:15:14AM +0100, Will Deacon wrote:
> On Wed, Jun 10, 2026 at 10:26:59AM +0100, Vincent Donnefort wrote:
> > On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > signaling mechanisms defined by the Arm FF-A specification to
> > > communicate with the secure services.
> > > While these calls are markes as optional, there is no reason why the
> > > hypervisor proxy would block them because:
> > > 
> > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > >    Because all forwarded notifications are inherently attributed to
> > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > >    originating from the Normal World.
> > > 
> > > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> > >    operate strictly via register-based parameters, passing only
> > >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> > >    not contain memory addresses, offsets, or pointers, forwarding
> > >    them doesn't pose a risk of memory-based confused deputy attack
> > >    (e.g., tricking the SPMC into overwriting protected memory).
> > > 
> > > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > > flow is covered by the spec in the: '10.9 Notification support without
> > > a Hypervisor'.
> > 
> > As it is only a relayer. Is it really important to check SBZ arguments and
> > fields on behalf of Trustzone? It doesn't feel it brings any security. If the
> > host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 
> 
> I think the problem would be if an update to FF-A allocated some of the
> currently SBZ bits to implement some functionality that we would want
> to filter at EL2.

I suppose that would bump the FF-A version and the proxy would reject it?

If we really want to check for those arguments to be 0:

 * Shouldn't we extend this check to other FF-A invocations?

 * Do we really want to also look into the !SBZ arguments to verify what we can?
   (I'm thinking about the checks on flags)

> 
> Will
