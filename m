Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A08E2FE57B
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313848; cv=none; b=c5cAF3ypyedieVnPCNqLt1UMXdU/RPaNqmsUAeqvKZaqUQtNvTXlVTDa70jkLsoC69ohfwq7s9/E1EYyRwxijVVFSkIUxt9zIkKZ0/2DhEo0OhS/XfU7w74eVjhMI2jXkzFC0vdeB0qgz2ceYiLywPBadIHOXY5weBFP6GEmAtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313848; c=relaxed/simple;
	bh=LzwH1h4lq5y9GcOkBDStvflsxkoSpTvpEDyfO/wlek0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGIB0oREkDBZWdiVxzns5uY7/6LpH8d6QQi79eCP1uU6EjERrvc1fcKsVoXlQ9Rde1l7b8I0szN+8SRNVKhn4HjxZbGBneDOSpB5mSi/GiQ8fyCZpm2GcJQXo1AMIzfqukb3yF5+ER41nFiqD81mA64yYc8zwPOw3/rRDngBfj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C80D51A0171;
	Thu,  5 Feb 2026 17:50:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 169DA1D;
	Thu,  5 Feb 2026 17:50:42 +0000 (UTC)
Date: Thu, 5 Feb 2026 12:51:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/30] Tracefs support for pKVM
Message-ID: <20260205125117.0b79f6e3@gandalf.local.home>
In-Reply-To: <20260204174502.06d6e02e@gandalf.local.home>
References: <20260131132848.254084-1-vdonnefort@google.com>
	<20260204174502.06d6e02e@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 169DA1D
X-Stat-Signature: h9e84gj8nf46jc5d1eypqiymijg5xeeh
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX193k99BonF8qsoA8POq9JGR6cSJ934+zxw=
X-HE-Tag: 1770313842-595241
X-HE-Meta: U2FsdGVkX1+jZ4cuHM+xa8vsrI/HeqIYZp+GIogIontNWqx6b8Nc2SH3bzCsJym1usl2Bl71T4qZrhWh9OUl9ZUEfsuK05tTdFjMvOlS8EbrCKUBr9uDcMrPm9wXXjZ1ZvVJkUDjDXLa5XG7I2Ta+E0QpwjAWfJlC8MufFM87HbwT0wXTNwzu/zgl5Qz+qGVM988+R+tnoYux7Xs1wjUqzsJHwNR1K8oUNU4coEfFeOtoXeQD4KujjFrlVefAN0dKTkpYsIly3g7Kuo062Gk9m1idIqRDzpE0FbZPdxe/T5SfkvdHKflxRezraVw370uNQuyiTXMa9uH8ftD/AL0fLwqGCHQwCLFy+bc3AFe/BGjdTEfSnnwvBzes3VlEi7Pyi3w7zsa+pkib7sXwjRnStTQqYYgHaSO0e7yJLOvuyc=

On Wed, 4 Feb 2026 17:45:02 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > changes since v10  
> 
> BTW, it's always nice to add a link to the previous version here. That way
> it makes it easy to backtrace from one version to the next (and reviewers
> to see what they said the last time).
> 
> Changes since v10: https://lore.kernel.org/all/20260126104419.1649811-1-vdonnefort@google.com/

So I finished my review of v11. Still some with comments, and the ones I
didn't have comments for I added my Reviewed-by tags.

-- Steve
