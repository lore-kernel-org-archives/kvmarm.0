Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E130E1714A2;
	Thu, 15 Aug 2024 13:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727546; cv=none; b=h8CcPtUSFg1XZweo+aK+RA5n2CzDaqLn5loKEJep9UrWKpCU7UD9ej+7xu1Ya300U58zQi3vIlDi+RMmiQIMVhfwUokC2kmGbnigWEUIdGr3Zk65HR89EfAeFP9YLLpU1G+mRxbySqFuWFBl7ntGsSHz47a6tX1Ipl1siMofu4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727546; c=relaxed/simple;
	bh=u1Nb2zJ/qvyQeIG+oFRaTPhjYXhnqVwW39e5bvwKTU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+GOugV2WNhn3tn6taNxsNaWLIKegPlIWi4l2R5vwsLWRMjBdToMRjc4r7KVFkUKKd+tRd94wU0XpW5gkC5y7xGJ79DrMgsIU+Z87y0RzyEUa/w4mODU1g+LM0SdVtY4KAOxbrDsscmOZoEt76rt6HLUe5voVtI4/gX422YVBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrCgTXhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrCgTXhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E88C32786;
	Thu, 15 Aug 2024 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723727545;
	bh=u1Nb2zJ/qvyQeIG+oFRaTPhjYXhnqVwW39e5bvwKTU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NrCgTXhLxPsx4CNiiXHXxt0v3dNVgh8OCNAuOtuAv7kSApfj3kty7ik1HMyt31FdH
	 NnyRjRGY2KUSUh/eYcSsxaRNGA78pDIE3mTEOmHhkhkVGtU4K4CXO/tK9EGcdrrbos
	 ROBpmUqkIReoObcB8KaxYtiw0Q3+er+3x5ocZHrA=
Date: Thu, 15 Aug 2024 15:12:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 6.6.y 0/2] KVM pgtable fixes
Message-ID: <2024081515-jurist-crazily-8cda@gregkh>
References: <20240815124626.21674-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815124626.21674-1-will@kernel.org>

On Thu, Aug 15, 2024 at 01:46:24PM +0100, Will Deacon wrote:
> Hi stable folks,
> 
> I noticed that these two KVM/arm64 pgtable fixes are missing from 6.6.y
> so I've done the backports. The second one is also needed in 6.1.y but
> it needs some tweaks so I'll post a separate backport for that.

Now queued up, thanks.

greg k-h
