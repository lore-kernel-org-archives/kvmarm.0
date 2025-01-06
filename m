Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351CC1DB37B
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 23:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736205837; cv=none; b=Rr64hArWv0yCw4YX4zWKgmeMYN/e5KNbdgUEKpMtXddVlNdbotdw4nImC+DW1CdwzAbGNilg7iNQ5nfl19WlnN5uQCzfMWzH1ZpKoX4Q8S/JllMyrRBgkyRiTu+64q+l3ULJjT6ytJFQPnPD5YIQ8XRAxPvtL64oNbne5f0Z+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736205837; c=relaxed/simple;
	bh=OEYq/rEy6/hbdmh2MT0bxPjVthoQLZK4+INfmZYEYjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdJK6rcMUvxsURJ0a2NhZkDw1gy0lsJX8bcPp9pLysGH+rKmqCqLw4lWBILCL/g7gJT+jrF16qc0TyKWDvdApdZ1VGfXUUMB4T6l+41fv5ClLsPMPedHZa5Y6/fDn2MrXpkufca1EDvZqIEvNQIcYTkcDDFYtthGXo+Fm2XcZm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QDP+2lni; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QDP+2lni"
Date: Mon, 6 Jan 2025 15:23:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736205833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n/MVW3wKwQVEQEzkvuZSJWY6SOrTiolGYkjM4qTiFeg=;
	b=QDP+2lniNTT+JKJRFgXs6zXBXhvMQJeKXfyVnK3LTBSl0sCDrmL+Mi3Z2VoDMYQJ86RUxk
	xuMvud68d/ESYKTesSxPpww7BndZMddNiXwcaLSKF+8swlUAjMaTjzTExiLQ0F8MCMQ4kt
	v6+eAspNeQJL/rTYJR7gBYHPRe8BAVM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Fix FEAT_MTE in pKVM
Message-ID: <Z3xmBcWcuQSXnrIo@linux.dev>
References: <20250106112421.65355-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106112421.65355-1-vladimir.murzin@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 06, 2025 at 11:24:21AM +0000, Vladimir Murzin wrote:
> Make sure we do not trap access to Allocation Tags.
> 
> Fixes: b56680de9c64 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

I imagine Marc will pick this up for 6.14, so:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
