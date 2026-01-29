Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DE2229B38
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646447; cv=none; b=DCsyTy9ip3PpT39vDQeMOBhZ6QPkVUWmOZy8KKjE4szzaT2UUOKtoHLak5lXm/3zPTGTy58pq64sTEtmulBp3dN9NkpeUbD0gfG+5tjoU6bXxbPz9i8spCWF8iCNdvkPFrD+zvcHHLrA9vWdmYnh00gdm88X5uG5poIja7FNxQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646447; c=relaxed/simple;
	bh=8948yjRw+yp/OfDpa6G4DA1Jhlz8pZjgwOMgIJEI+68=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cS5Pci4HHuGCpn8fy+04wpED/izI8oykWenGoYgTtiV5xRwVrcOXU3jEuS26CoEIL6jEM7sTWUPfwPyqkYgpTeA5VZ4OtZCoY3CqxLHsItSz2BM4OwgHYe2aEoe8zQiasI63/0kqdl+lD8wZL3Y5c1idGzlwxfmK/AytnmPBpbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 600E059E2B;
	Thu, 29 Jan 2026 00:27:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id B546C2001C;
	Thu, 29 Jan 2026 00:27:19 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:27:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 08/30] tracing: Add init callback to trace remotes
Message-ID: <20260128192729.7e09c666@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-9-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-9-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B546C2001C
X-Stat-Signature: ko7jp31m83cuowy3gmbyif7tpnmo83um
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19duKg3l6ZY2vUOvbsy0jhysLNnndHhvHc=
X-HE-Tag: 1769646439-261279
X-HE-Meta: U2FsdGVkX1/CWtB6rVpZu6SyQ2yta8IY4pPxH5RFXk05r/TLryalN45JzPtrAhUFiBqbDUsLn5r9igAHwxH/5OKRzaCKTq2lszcKSv65QJ27wZGyNgj19pzSTLW8VvSJ6nM2sNe43731HsERjpgo3AdB0JKVHQQAB83QdisBzDA4ws57SP/5KwCFjKR9yqCyc2ptojw40Na7NOYUE2OjLj44uRzdFW9O93lzFzFo+0FM62zN9MRRuZ8Q/UPMAPpHkmyXzJy3hAIEifq4hbYbbGH+zjdnicEoQROVK/tdlbOKoEZsTtKROUO9i6s4ZsqCw6J/EJEzzOPDMMUa2GlW3tgWcPPwq1I5/1bBKJmC5s5ykpPJrnxSTti/g+9dsY90WWHf+g2fdFvUg9GiOVRwJw==

On Mon, 26 Jan 2026 10:43:57 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Add a .init call back so the trace remote callers can add entries to the
> tracefs directory.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
