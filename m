Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431C72E889C
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153779; cv=none; b=EWgTmDZxLzKeglx8vMgZoEdpczgFzifL0pL7iuQIp+u1GJlg1cdSP4sNMKhct7HyqsT9/3EanEz3Kz+I+TnbpcutHc3qCflpOvN7Gdn0GY6fcoJvDOcwL61RfAiuTQb50W6T8/4RDUQGEkvPC8OBraBdJV86z0JalIfID7s4odI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153779; c=relaxed/simple;
	bh=ew2Ld+USg/0akIWZd2Zhhd+hA5g25bVPfQ3z1Vk7d0w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBt2zP+OTpCpujyckYeOI/plafgskYmI+77VTDxMhA/gQltHbemT/MENlX9u4hjP4Dj9QfbjmfjCaO02NUhO0sYtlLGvjsCCie6sX8GozpZrLIE+69zx0C/VEXNBbtTqqRXF6s8/1hoI3z8THDROIKdVAcIFLSG/wecKhVJ1c5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E62B1B6C86;
	Tue, 10 Mar 2026 14:42:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id B501E40;
	Tue, 10 Mar 2026 14:42:51 +0000 (UTC)
Date: Tue, 10 Mar 2026 10:43:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 00/30] Tracefs support for pKVM
Message-ID: <20260310104301.665bc684@gandalf.local.home>
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4dz8tkqbqdur7t1oxrqypc1fny4f8est
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: B501E40
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+DNCjV7dq3BIMgJPb6chTxzLYz8EtnyHM=
X-HE-Tag: 1773153771-423745
X-HE-Meta: U2FsdGVkX18n6LeKxHu/K8lrNosbg33R7MUM0BYl15C/a6ynYReUnFyq+jAHHl9dj4LFnQshyXL7OLItBj+Eouj8fvPWaNp+LBnrNYZf3jEjjzX+E9q+iYmzFNgGYC4oM2qcAfvLkzMgpczH6srVhwqHNl5YyzW763zKc+lvNjlXGgELd3NCBbMrEf0wcGQyDbN5iiU6Djv/+CTyk9l5zNAjc5aqNh0vIjGFmfr0g7FOAfXUk1swp0mgBxbCpDyO2NX3K6xUbTxq8kf1UPQ4lWjplk2N71zu7idjH6ZMuBi6XoGA/QJ1Vj612bYcVTPm/l0TqqB0xWcxDSOvK/OipdOWZhpsceIVikH36Jz2YobqoPOoKsqmGQ==

On Mon,  9 Mar 2026 16:24:46 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:


> 5. pKVM
> -------
> 
> The pKVM support simply creates a "hypervisor" trace_remote on the
> kernel side and inherits from simple-ring-buffer.c on the hypervisor
> side.
> 
> A new event macro is created HYP_EVENT() that is under the hood re-using
> REMOTE_EVENT() (defined in the previous paragaph) as well as generate
> hypervisor specific struct and trace_<event>() functions.

I pulled in all the tracing related patches (1-18) and pushed it to my repo:

  git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace.git  ring-buffer/for-next

It's based on top of v7.0-rc3. I'm not going to rebase that branch,
although I may built on top of it, but for now, feel free to merge it into
the arm tree and put the rest of the patches on top of it.

-- Steve
