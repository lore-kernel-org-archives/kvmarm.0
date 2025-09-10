Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240E92D3731
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757524024; cv=none; b=MM1EmNQ8qlj9zebHZbEexBrSqx1HyhirVtOAO6mVKU2dfhLGz1WpPczUF+w+rKWutfu1A4vO4rOF/nBIsS+rrx/DiBr/pPCkuVHU2XLM9e1BESVsxmRusRZQYofBU63a0uQNqwRcFh1yB/DsvgjpG2j8w8gD30zSatB2z+Er0qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757524024; c=relaxed/simple;
	bh=7De7/KamC02E2b5EHbxS6ATHgldlo+QByCWY9AZEpNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGjYg59owqi0EdYLq7s0avKd0JFrjiyGV4Em8pU0yZ8Zk5YY4P2zT26kuWu1fWsI9lxjYspsZuZxNcJTfQVVAwo1w5D4RDTHqeT4ZPtlMGuJNFSEzX2PZBNJzWGCNls0kHI9I3YpoROHih9YRIr/oizLuYA1pVl8WlJ+hqzcz58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K7qaWxcv; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K7qaWxcv"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3df2f4aedc7so4027247f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 10:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757524021; x=1758128821; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eW2e8p73Sm65C62B3d7xoYycH9WMEA7fbE5AMLTODfI=;
        b=K7qaWxcvq9dCKMciiSx1boz21EgRq4IAvAv32MLRpoutLudwEapCd03iX0zDkvToxR
         NADxd9W4B58IjOqaTHSKDvUT7aBBVhlSG7b48mdXMpaHMyA+3GMJSgZei3wIGKhf8YOi
         sMWfnCEUh0MuSf7B41JxScVofMxeB56yTCyRo5LTOHlVijKrkSTYcxBOPpvRskS+OA+1
         IkVmgP7xHM4e461/FSTscB5Uol4YUUWq8mM2t+QbQPMRtHg95FIFE5W9yZvnTMrtwHxK
         mmN7fu/ugj+zznpwC0jlt98RpaXNcvna8Gl+Z8NdTYVfzE0pGoQLTaSmVnGGnB6ChYVh
         IyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757524021; x=1758128821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eW2e8p73Sm65C62B3d7xoYycH9WMEA7fbE5AMLTODfI=;
        b=CKsM3NBm/dH5TV1A1FlsnqxnyNpw2BMErZRbcnIfF02hWCfLpybyBjza/fYGOCPfrL
         ZSRoxojPL2T9zHVCVvyoaUJBAFFF6M2e0MXfGxVb69wDNDgfZV6OjuAEU4j6zgQ6jC60
         RtwQyNag7//xbIOngPh7sDWn32j56ipobE33hjdMT+qJrE/DjFiwgeQ+KDQhzoCMJ6Ut
         PZWWajQB53eofYJwracaA+KydqDM/uPDZ2YdD7BIy0poP5enm8D6XrWN0bVQxaMoTQhk
         IfB1lCMpj9soSU/1yam4lNovFJ0Yrd/XnXEEx8LIsHYV1o/ALPCTLytWAgnJF2J4qnyK
         QPwA==
X-Forwarded-Encrypted: i=1; AJvYcCUTvtYPWj+uQn7pyxw+/Z627dCJPA0M52bj+HIgXTlQiI5juCkHRX3bUl7gb19FZlD1jAmcZ58=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX0p/6lJCN+NclHfXwpqdrEBJ00lsvNRpqjquJuunzJcZpo44L
	07RrE0lkr1OwsJzaHpZUZW6vRjkTr4Om8ojK3HMFrkA0R+BsEgdJIehGiHYrv5QWFA==
X-Gm-Gg: ASbGncvri/sjxuAEC1wamln5VUPXUjP6QPclpoaPyDKqvRqV+jIXwEF1oHcbCdiPltu
	Af5V+avPWLNfjw7GxWvaD812XhpiHXiGteZJBnftFreoBnoQV/SadcpT/MxcFaWq8fPOmD5Wjy+
	7B2bv9Oy1jvUzkejdDjXrFSK/+yjniWkzrz4bOHN43VHILQ9pnxV4odCOFpCUJUn8tvMS76VMQi
	djjGwSN7oeFz2A7AmPCo/dOcGuiZ9Zlr4y+76+dojIaZJHot1BYZ/bXpLLNcmpPXfLL+afplWzQ
	sUP0mjGhb745ZXlUJFFqFLL6zwEJpdwjtKsEjUoOqEEa7I6/3Mf69Azivr74gLFLIHV115P9i9A
	28+mNU5uIf43NoNPOYQkgMMclxN7G1oYc2MlVaFSKzLmmcZFo38RVjko69S6X6LpIluFjyBDr13
	/MzqPivcUkgWVXXqc=
X-Google-Smtp-Source: AGHT+IFpMY2LdotLVzenSyom37/MyUBFp2vGP8SWQXN5ZGAgsTxLPg9ujzG9esizRfQMqbIwV/AfZg==
X-Received: by 2002:a05:6000:2f87:b0:3e4:f194:2872 with SMTP id ffacd0b85a97d-3e64317ef24mr11131229f8f.31.1757524021156;
        Wed, 10 Sep 2025 10:07:01 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df8247c3fsm34826185e9.11.2025.09.10.10.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 10:07:00 -0700 (PDT)
Date: Wed, 10 Sep 2025 18:06:57 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 15/24] KVM: arm64: Support unaligned fixmap in the
 pKVM hyp
Message-ID: <aMGwMQBwxRPPiCer@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-16-vdonnefort@google.com>
 <20250910124742.34185645@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910124742.34185645@gandalf.local.home>

On Wed, Sep 10, 2025 at 12:47:42PM -0400, Steven Rostedt wrote:
> 
> Would be nice if the arm KVM folks could review the second part of this
> patch series.
> 
> Vincent, I finished my review, and you can post a new version. But it would
> still be good to get some input from the architecture folks.

Thanks a lot for your time! 

