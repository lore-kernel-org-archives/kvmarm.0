Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F2E40913B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887460; cv=none; b=alonv3xUjKpX98VqX6wg5DfsWniMb76D68xmg1WX3p/4EJpHqYbaRNl6bv3r1QddFZWSydAON8NBDg0ouovKRVyuCWYd1oCKcOqVYBKSgrhUVFiJO2JrNJwgiIRF1DXQXoY8Ne6L3Jnx9Xr0xTk5fcYckI56DmZqkABYUZ++iGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887460; c=relaxed/simple;
	bh=Lkhnv5EnsL0nX9+MZM2St8jzGNKWW0W7n8nPthMawW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnNZwvtWaVx80FS8fsjYooY80Hi27KQTwolXHrbTc3ox5XG+imD+FvfJTDyR0Z6HEzeRoTqxsMMwEHl7wdLn161aE9riF1rXdvT22saw4yX+j33QewKlNCYQxnImI+yTrjcNgY6INvzLtxf5zjhyky+8nUSc1lcX6ciVD+PskaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qHbgmuYI; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qHbgmuYI"
Message-ID: <4cc55a8d-c3a4-4a14-959f-9e92cfd45434@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779887446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cberug4IISTu6p+MA4PASefJzlyZrYOrb9dspFdS+VM=;
	b=qHbgmuYIUoY/ZT9znE59+ArCqODQX4CChARtaqIFINlMeTlcUSl+yJAEGuif2t5BuW7EXW
	Ex2OB1hnYM+HKvRZwRHwVHqe3Ixva4OhtLRQRDnYf/jOcqIAyD5w8GRLBEmm0iAsbEMbEa
	aOGgTSsD9wiSCJOmH5Uj2VhlEujsM/4=
Date: Wed, 27 May 2026 14:10:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [patch 24/24] ptp: Switch to ktime_get_snapshot_id() for pre/post
 timestamps
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
 Miroslav Lichvar <mlichvar@redhat.com>, John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, thomas.weissschuh@linutronix.de,
 Arthur Kiyanovski <akiyano@amazon.com>,
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>, Richard Cochran
 <richardcochran@gmail.com>, netdev@vger.kernel.org,
 Takashi Iwai <tiwai@suse.com>,
 Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>,
 Jacob Keller <jacob.e.keller@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org, linux-sound@vger.kernel.org
References: <20260526165826.392227559@kernel.org>
 <20260526171224.499777655@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20260526171224.499777655@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 26/05/2026 18:15, Thomas Gleixner wrote:
> To prepare for a new PTP IOCTL, which exposes the raw counter value along
> with the requested system time snapshot, switch the pre/post time stamp
> sampling over to use ktime_get_snapshot_id() and fix up all usage sites.
> 
> No functional change intended.
> 
> The ptp_vmclock conversion was simplified by David Woodhouse.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

for ptp_ocp:
Acked-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
