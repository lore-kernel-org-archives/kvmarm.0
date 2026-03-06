Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558073A4F3E
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 16:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772815068; cv=none; b=pVhmdMXH/YrhdveZ6sGuFhsTbQjaFnVNbZDTHkKJmUq5n/czUG0fhLU0IUerGqsZTmBXNAUFXYPLm29SE0yBBJtq3+nOlBV6SqiHPxz6ofJoOpe3Im8dkFToSVh0UOgron0wSCiuee4DltJq/ciMkD7846s2nugLMcII/8QoHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772815068; c=relaxed/simple;
	bh=mGQAm165RgJQnpaCtmjRXUyFonFh4yiQd8/8lb1ELDI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=CgMUSJO8Cx1ofrMigrIkFkXNGDjn/+awlS5A/XXeM6CRxdDoQ0EgXa5cu5HJa8ClvWiujj1NhC3seEdUo2EDc6yvJHRUiONq2fHLYWmlKN/5Ri39UV/C9VY1BQN+h9WCeYP9YknJ1GxO9WGTyeiRRqynzIEZVoqyggBUIEYy5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Sleaeb31; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Sleaeb31"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1772815061; x=1773419861; i=markus.elfring@web.de;
	bh=TCfMqLlrkbRKYgYFYGoOVPOZ3mtq4LlpJAeymSRod98=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Sleaeb31xkUheefJ/t933ARsjiKjsbTwmSAYzI2NboDhCl7SFZN1blIgoF8JDyPK
	 KAYBLazflj5kbUDkWuse/HUnOWrc1LAP5pdzUw2qdMGJPomCnUQQIUrcZw7fWHG/e
	 gSglkP5c2tScGPeHZOhh0Y8iY0gvh09keE5bjJkj0zzH7HSx5xW0AYk5RAJskFRrL
	 ALTdIK7nWCFDAt3gIJEATOnfG9tJNVJkIIF2b1KBM0DnjZ0ilt40kiDwaeRh2bhWG
	 HJ8eoESw0Wgc1o+VupLSFSD1NpAsKP1+D3Aovd6L01WZAgXgAPccNpkcUJwtSnf4M
	 y1mdZ9Mqws/mzVJPLA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M8C09-1w28oQ2Yhn-000iAs; Fri, 06
 Mar 2026 17:37:41 +0100
Message-ID: <677c7ad6-6e67-4011-b2d0-03d0d58547ce@web.de>
Date: Fri, 6 Mar 2026 17:37:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Vincent Donnefort <vdonnefort@google.com>,
 linux-trace-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Oliver Upton <oliver.upton@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Suzuki Poulouse <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 John Stultz <jstultz@google.com>, Quentin Perret <qperret@google.com>,
 Will Deacon <will@kernel.org>
References: <20260306143536.339777-4-vdonnefort@google.com>
Subject: Re: [PATCH v13 03/32] ring-buffer: Introduce ring-buffer remotes
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260306143536.339777-4-vdonnefort@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/7M96EMDdymY+btShE19XvuqDjcyQNoA88jOa7lXVK9lidCIu9B
 19mAqvnB/VTl3sYqz8/10ku0BD6XiZD3H6O2tHNK2GOIk/hDfrOjfS7GmXU69FMGL8Rr0oi
 UzoMwPc095HwOs2OphD7g7r1mQNLXv/sOjaDiZZHtgYyXepez8oBU28OxnEikvG7l35P6Yi
 3oHtX+2xWUFPDZ3JfT1wQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:G6Dq01SMV3k=;waooZldAIodUPIcbwT2ijRSgjK/
 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

=E2=80=A6
> It is expected from the remote to keep the meta-page updated.

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.0-rc2#n94


=E2=80=A6
> +++ b/kernel/trace/ring_buffer.c
=E2=80=A6
> +int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu)
> +{
=E2=80=A6
> +	cpus_read_lock();
> +
> +	/*
> +	 * Make sure all the ring buffers are up to date before we start readi=
ng
> +	 * them.
> +	 */
> +	for_each_buffer_cpu(buffer, cpu) {
=E2=80=A6
> +	}
> +
> +	cpus_read_unlock();
> +
> +	return 0;
> +}
=E2=80=A6

How do you think about to use another lock guard here?
https://elixir.bootlin.com/linux/v7.0-rc1/source/include/linux/cpuhplock.h=
#L48

Regards,
Markus
