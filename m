Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A0C3CE4A2
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727392; cv=none; b=N2NRJUBQ7s4wtQhaEwDW6TgyD4MdhN0J8lVjSfPcBzyMZTZV9ySYkbpO4mNma6YvId6pmo/2Wjk/SWwLz8BWRtg5NEgbajsjVroxpkR9KHg4zIIs0UkQC/3xwehBiTaLsv1pqYxmYZc3JZFjGXLz/vZqjoN4zY2ZBdp2sZp/ozY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727392; c=relaxed/simple;
	bh=REZCD/bjwXQD9ItoixE5zLBBAo2tTupKDiF2S6yhHPc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PiOR0p1iEi0Paza10FeYY/yZIYwScJwRkECVuMrQzLKoSUUPivsJq5THMfbIUalRt5s8HV4BcI5cgUUFyhhB/brFcwZpbxk5eX9WvRYhhhAxHgFyTYPxa8InngHqEsWPMecfAdseioht3nQNrAeaL/4+tAqSdx74JJQt69YYtzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F1AFB6D06;
	Thu,  5 Mar 2026 16:16:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 06AAC17;
	Thu,  5 Mar 2026 16:16:24 +0000 (UTC)
Date: Thu, 5 Mar 2026 11:17:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, jstultz@google.com,
 qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/30] Tracefs support for pKVM
Message-ID: <20260305111703.6346b243@gandalf.local.home>
In-Reply-To: <87cy20eeg6.wl-maz@kernel.org>
References: <20260219150307.14538-1-vdonnefort@google.com>
	<20260219130220.063c8db3@gandalf.local.home>
	<87cy20eeg6.wl-maz@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hjpmqngd9ddfjxdxzzo1w4jhxdng6wmr
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 06AAC17
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18CZlcLb/ptcfAuAKzvUKSGTao+9oqfTCI=
X-HE-Tag: 1772727384-772492
X-HE-Meta: U2FsdGVkX195vWpGBKWyqUWB3sgYzypwSlcv/h9gmg0TBmzfLJ+iJuAAW7JoYt01B0eByBfm80sD9DsxCpM5Ex95OHexPsc0qFg16Hge7QLPHlxS+CQvGowxN47UNGBfUGBYJAeypKYP61yfPCSTq57dgAktN2PQfGNpmNcjcxvNgvSLjaZSXDBiZXfmjSlbmObRDIyv7zNs6C/sXoU8ONKtSpvgWKfR9FBm6yGPlDmT0QM9iMzDIaOkSFBm0/8rPcd5RZ3lAfWOEw7woBi4TGjkhIBBHHU14acjwV/t5MLjLqx9u72DWZm7uc0EJZDjZkniDWeZDYruIAyHW8+voCjfsUJJEiDQ

On Thu, 19 Feb 2026 19:11:21 +0000
Marc Zyngier <maz@kernel.org> wrote:

> > 
> > Then the arm/kvm folks could start with that branch and add the arm/KVM
> > portion of this series on top of it. This will prevent major merge
> > conflicts in linux-next.
> > 
> > Does that sound OK?  
> 
> That works. Just send us a link to the branch after -rc2 and we'll get
> that sorted.

Vincent,

There's a few minor conflicts with this series and v7.0-rc2, can you rebase
and send again?

Thanks,

-- Steve
