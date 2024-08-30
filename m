Received: from e3i12.smtp2go.com (e3i12.smtp2go.com [158.120.84.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E8D14E2D7
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 20:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=158.120.84.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725048565; cv=none; b=YWrvuokDqutDRMMhwzR2T28nUffdvpTzLwEwuKzSbGsDCMNpK8LJFxntPkp2Z2jJxe8PAOPYEI3nWzuefe8GbKUjPn5Rc7IOhT+19y0ao7sYN42pEeMgTnUQZvkHLWkO+RQcrEVDS5eyCI+/RpNfU6KJaSpfAv3etv884o8LTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725048565; c=relaxed/simple;
	bh=VrcLFN5tqkfWY7mTHOYKMf0e0KvomCFsMPrfJDAaMSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qScC8+3yaBtA9K5fk2cxJd3VSh9TkllFbcxN2sn+SbuIQkwOeZLnGJ9PrExOylMEMtBiEuoiar/IN2dH+7RXr/Q4ZYs2YPfDLi38i5UQBhVaLivDViU+NsIPBIBg5b+96Q96V9dmsflxoh8wBFrjlKbdSI/pZ0kNe9n21GBb8Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu; spf=pass smtp.mailfrom=em1174286.fjasle.eu; dkim=pass (2048-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b=iXlNoJft; dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b=iKXSggyg; dkim=pass (1024-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b=P7Vd6NkS; arc=none smtp.client-ip=158.120.84.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em1174286.fjasle.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b="iXlNoJft";
	dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="iKXSggyg";
	dkim=pass (1024-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="P7Vd6NkS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smtpservice.net;
 i=@smtpservice.net; q=dns/txt; s=a1-4; t=1725047640; h=feedback-id :
 x-smtpcorp-track : date : message-id : to : subject : from : reply-to
 : sender : list-unsubscribe : list-unsubscribe-post;
 bh=8ffM0oj/VoAWiRvIYhx2YzkqNpRjhG4e8iNPq0uer6M=;
 b=iXlNoJftuPL7TNVFD5ZiRqTS7D60gdcqLITTEZ/zQQsjHQ8NavGn4OjOUIn5HfBxrTpbo
 y7wvYdhlFGjHiUbZxpsoPinTU2btj4ZCLPilxZqU8Qwt0RfVzg8BNUbb1sl5Q1fNi/DaJGV
 I6x0LQQaLYru5tN0SaNmiJ22A6hZbDCWHBdQjJuErAccmBFNU9YN/mHOo4mJUtwIgwvOAZI
 g2iesxU2n/5ZyyYmddR9Kg3cYpI0ZDuZFCRzjQPGkLkV1VPz0HC8c6g9fMQLpQfJI6LSOdZ
 6MQsBqkREXu51q3abibiSHHSEaPxZdUwlXFraiMEy9O0hGGkxOlDJhRznpCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fjasle.eu;
 i=@fjasle.eu; q=dns/txt; s=s1174286; t=1725047640; h=from : subject :
 to : message-id : date;
 bh=8ffM0oj/VoAWiRvIYhx2YzkqNpRjhG4e8iNPq0uer6M=;
 b=iKXSggyg+LBfdCYiW74qh1xev5pawGrwF3VrlrlwTGFEzGlGjyjC5DML3rZ0g8Mgv6HEr
 iWksfv/l1Zu7HlAq82NiOYd9SJJFXqgNCFlyAuFyYMO4qyfIkZP7ATm42gZVX4q63yvDUjz
 xKUhFE03uVkrNkfR2qmHcDV4TUUaOBKi+/dmFnqSTeG3C3CKzAgNfPWkEqCuJm8Vc5d9T5u
 wRm0TMSo4rxHwc9zw7Ki5H8nyNEBLWn3YveVvSqUjXdjR77DjUy0sChgB8KeIyz5c7yH37j
 096hrOAdIlKSnEAnAAZ3lgdqNpp1IhSAK92V+pnfIO2u9j8EaiRY01bqc5Jw==
Received: from [10.85.249.164] (helo=leknes.fjasle.eu)
	by smtpcorp.com with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97.1-S2G)
	(envelope-from <nicolas@fjasle.eu>)
	id 1sk7gj-FnQW0hPpdBf-nWmg;
	Fri, 30 Aug 2024 19:53:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
	t=1725047604; bh=VrcLFN5tqkfWY7mTHOYKMf0e0KvomCFsMPrfJDAaMSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7Vd6NkS50dZUF4ArGNPd4emC0HPqVDT3dc+nak6w/kyFZyIa7wpU0vTqmsiIkRep
	 lFQ7rFhNaD2Mf9eA7RsNhjnIHPRkgubjb0TmusaqfHzYKQpJgQpvZs4tHW5Z4AT4vC
	 fDqmIJfHaxoaJYo+8KfLKLIUurdYOyn4DfkqTbOE=
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
	id 423D3449B6; Fri, 30 Aug 2024 21:53:24 +0200 (CEST)
Date: Fri, 30 Aug 2024 21:53:24 +0200
From: Nicolas Schier <nicolas@fjasle.eu>
To: Daniel Gomez <da.gomez@samsung.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
	William Hubbs <w.d.hubbs@gmail.com>,
	Chris Brannon <chris@the-brannons.com>,
	Kirk Reiser <kirk@reisers.ca>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"speakup@linux-speakup.org" <speakup@linux-speakup.org>,
	"selinux@vger.kernel.org" <selinux@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	Finn Behrens <me@kloenk.dev>,
	"Daniel Gomez (Samsung)" <d+samsung@kruces.com>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH 08/12] include: add elf.h support
Message-ID: <ZtIjNBhqdxmMBxfM@fjasle.eu>
References: <20240807-macos-build-support-v1-0-4cd1ded85694@samsung.com>
 <20240807-macos-build-support-v1-8-4cd1ded85694@samsung.com>
 <CGME20240807110435eucas1p2eca071b0a0122b8686d43c57bd94dc8c@eucas1p2.samsung.com>
 <2024080717-cross-retiree-862e@gregkh>
 <dxkmmrlhlhsrjulnyabfgcr37ojway2dxaypelf3uchkmhw4jn@z54e33jdpxmr>
 <2024080720-skyline-recapture-d80d@gregkh>
 <20240807-mottled-stoic-degu-d1e4cb@lindesnes>
 <20240823225450.spuvjs5b5ruujim4@AALNPWDAGOMEZ1.aal.scsc.local>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823225450.spuvjs5b5ruujim4@AALNPWDAGOMEZ1.aal.scsc.local>
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Feedback-ID: 1174286m:1174286a9YXZ7r:1174286sfGQOlJjcl
X-smtpcorp-track: xIy87U6BijDn.ytGDcTpDVN4o.wyiBCgGVLft

On Sat, Aug 24, 2024 at 12:54:50AM +0200 Daniel Gomez wrote:
> On Wed, Aug 07, 2024 at 05:46:03PM +0200, Nicolas Schier wrote:
> > On Wed, Aug 07, 2024 at 04:18:54PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Aug 07, 2024 at 02:13:57PM +0000, Daniel Gomez wrote:
> > > > > Also, as this is not internal for the kernel, but rather for userspace
> > > > > builds, shouldn't the include/ path be different?
> > > > 
> > > > Can you suggest an alternative path or provide documentation that could help
> > > > identify the correct location? Perhaps usr/include?
> > > 
> > > That is better than the generic include path as you are attempting to
> > > mix userspace and kernel headers in the same directory :(
> > 
> > Please keep in mind, that usr/include/ currently does not hold a single
> > header file but is used for dynamically composing the UAPI header tree.
> > 
> > In general, I do not like the idea of keeping a elf.h file here that
> > possibly is out-of-sync with the actual system's version (even though
> > elf.h should not see that much changes).  Might it be more helpful to
> > provide a "development kit" for Linux devs that need to build on MacOS
> > that provides necessary missing system header files, instead of merging
> > those into upstream?
> 
> I took this suggestion and tried pushing a Homebrew formula/package here [1].
> I think I chose a wrong name and maybe something like "development kit" would
> have been better. However, would it be possible instead to include the *.rb file
> in the scripts/ directory? So users of this can generate the development kit in
> their environments. I would maintain the script to keep it in sync with the
> required glibc version for the latest kernel version.
> 
> [1] https://github.com/Homebrew/homebrew-core/pull/181885

I think it sounds sensible to hold that formula file in the upstream tree.  But
I am not sure if scripts/ is the best location.

Masahiro, what do you think?

Kind regards,
Nicolas
