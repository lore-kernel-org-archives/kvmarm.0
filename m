Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6687934D918
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767805171; cv=none; b=HRfir1Frel64xlsDG2jqxFXYDDkRJQQ8prX4yhWPBZGCDf8DxvWjpARS/rBQu4IXZKZOj4xXWqv4B8ycoWQu5kNVyzqaAnsP2IeHDOtgGf/LQYhUqx0K75Sgi58icQu+8gHXoUCJcnOjaxfl1T5ZfOLvUkPWUu+5udsl/Fnwyv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767805171; c=relaxed/simple;
	bh=uGId2twk8vagHHovwim/VkM3xk7H/dWaYingV8uZFAw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZLt4FCY9eyirtULnETLzFv8j7ZDHRmn5ZsS8rpK+uNwvY2kSBEc8A+LFP/R8qCRtpbNflpdpV6z0ZdhqlD+b2QyW5X8JIyjHp5G6QtzIcpSk1Nr311KxhhI7EXKVEyO44NDTRgzpHG7BKqYi4vOaUl5hGG5y9dYGN9YqZdqCfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6C631A0474;
	Wed,  7 Jan 2026 16:59:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 790192002C;
	Wed,  7 Jan 2026 16:59:09 +0000 (UTC)
Date: Wed, 7 Jan 2026 11:59:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, jstultz@google.com,
 qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/30] Tracefs support for pKVM
Message-ID: <20260107115936.4f4a8965@gandalf.local.home>
In-Reply-To: <867bttmmzw.wl-maz@kernel.org>
References: <20251202093623.2337860-1-vdonnefort@google.com>
	<867bttmmzw.wl-maz@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 44shsiadfkcuojskzj7atpzqz4f1uwqm
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 790192002C
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19LQ9MFuL2LaCgUQAtwlkXmJZlyiYnSKhM=
X-HE-Tag: 1767805149-424335
X-HE-Meta: U2FsdGVkX18MLNG4uKP17KPandcrOvhgFIeJTSOG5VxsbSslz/R9wG2Hsx0QalMvyVcXnpgQTOoOScyZerqNlskwc42IA1hV0ImsJbTcdkGJofwc5uG1wlHcJIORHfl5vYLAL/FXL/tWm0jGSydjqQc+fRan7we14dHrIVnHBVZCS8WmVhNEQ6GZ0m8zDamLgi5cAJcIZU608Qg3QVo5sT2LS20XQ2MTA335YRO0jTXzAx/cFk7OcVSNFcY2jwRU2v6XUh3vKC2P6jk2IIGwNFfOvwxzBhYnOVtLslkmOw7QNfW2rAGcItsSp4JdPW0ETvSfxDfcErPvz1emNfCoBmKyuO8R+p+f

On Wed, 07 Jan 2026 16:00:19 +0000
Marc Zyngier <maz@kernel.org> wrote:

> I quite like the shape of this now, at least for the KVM side of
> things. The comments I have can be addressed down the line, and don't
> impact the actual functionality.
> 
> Now, the first 18 patches definitely need acks from the relevant
> maintainers before I can queue this.
> 
> Steven?

Yeah, it's on my todo list to finish my review.

Thanks,

-- Steve
