Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EB3F9C0
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 01:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773020737; cv=none; b=U4VVEp0fLLlobuwNWcnLxU0dkmbSV1sjqzREVyWgkAZsUssHXdjdMqFPpWjLLt2eLqEIkUVpwYJi59bRjDj5gv1JPESVshtebfAdN8mZmbt8FOnV7WL9WIOuSUWEImRHA/qV3jrXbGxlbvvyJ24BinpGQj4IDpXHcUpggoVNtXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773020737; c=relaxed/simple;
	bh=UPl7EyK46nq6QANiAnbrrAMZtf82iLVfI6iSq1CexTE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hv3LhNz7SuvqpBjC4yexnn2g5/fbVnMYj+7p9v2n175S8datsbc1ooFTsVtU477L0DWI4qG4ssEnY5tfHcqatZwMyQLrX42cCcT/7pkte7cXRrdY2Ad+j3hJ8wY8ofjpc47uabBoe3WtYcFEi5Wjkg/YsykXP3sHhnjo6HmdPkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D533D1C959;
	Mon,  9 Mar 2026 01:45:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 0486E30;
	Mon,  9 Mar 2026 01:45:28 +0000 (UTC)
Date: Sun, 8 Mar 2026 21:45:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 00/32] Tracefs support for pKVM
Message-ID: <20260308214527.67ccdef8@robin>
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0486E30
X-Rspamd-Server: rspamout06
X-Stat-Signature: 3uonkhtsoep454zd4idfdnr1egzr6gti
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1986IueEcbF7lKfSMe3+OUW0/FjB5l0zI4=
X-HE-Tag: 1773020728-268821
X-HE-Meta: U2FsdGVkX1/fQHUtu2zwWLUleQxw8wSkEUSAwD5DuDzK6zFikmh8PU7S1Qmq0swLPt4xvk7ISiEp/nNkwyfJnGTaZL9dUWVeHQcSbjmHJTHteIpq3R6QvA/nAS37dKeMkH57C9iXBB0/ZbIWsTaNTXymNQNqMUiMsQ2rPr9J7pcU13UZf8cXmuu6u6pKZv3dO7QPR4BGNEN2lM2XfdWCL5mBCKSM4MiDzg8ECLIegCoYhWsX/G7TLF/wiCkd82R0nlB1aPOlYDyuts32APwxWlxvsnM842Dd7XjB8q5R3hbVDy2QULeYPBsq5YWG6zu5

Hi Vincent,

Unfortunately, this doesn't apply cleanly to 7.0-rc3. Can you rebase on that?

Thanks,

-- Steve
