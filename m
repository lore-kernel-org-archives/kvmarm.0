Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1FE322C66
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757434483; cv=none; b=CY1ev66SKsxt+IlEy9PW3gygBc+Rd5YA0OPpTf2i+BHCzhK51C+f3tFjVqC0GwqVlGdrQe+NywigMEO+DID4OaLqOR1v6gVExaW2YzkYG6Cvef2iX5OqROE1hmJFeQTX6N+j40vNjzu9cP/y/mb5RVsy/wUPGye+C/r2anm/QAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757434483; c=relaxed/simple;
	bh=Mz5sKRsdSfgn13KUBdRg6Vvpk9EwU24uw45F0iw35JE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eiuhp3piwrAM7LlXGty+VLIIPSvy+aSidn33lfR2prGJN+jee1CJxJ0SUltxU7Q+LtckoSSY+RMGGKsoy6Sg1z42TRbxjadgLsNYvy4hpfa/7frxh8p9Bf+/iuLjZiKrJjyTBwR7k8AEuYrsbJcPoONGwBT8GZte2T8M4xyCJZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQyF5JLe; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQyF5JLe"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e249a4d605so4675128f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 09:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757434480; x=1758039280; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t3MUxe5idS+BGR3j6o3LYiON4iTePZTn2nSk7Al8lT8=;
        b=rQyF5JLerwH+JlP8pDupnatmdtiLIVV9+otDCg7TxoS0Iy+GfSP60q/kO+OqjsFdpI
         S8RG4TuXX+V0oQpAM3RngiSJkePgpz620Yj0SdhYCizvLjQe3RdTIY4JmXJYI2x7jx2A
         IwnmgNUWANAwcP9g2UIbJlUopZvyUeY3bMQqJ9EMUZduUOopZTkXlDZu1GFpUAtjqq/O
         nahrSshzc+fmzELPYdxGk6Bh0Ewf0IYE7AEUkwkTVJCeV3bV3UupW4rpDCB7ek/trwKU
         qUThuYF6o2aYvz14Y9dtb3WacTdLj4V/cbuyxBgKF15HLmuVPPupBqa1ODEZZ5IR3b7+
         LZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757434480; x=1758039280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3MUxe5idS+BGR3j6o3LYiON4iTePZTn2nSk7Al8lT8=;
        b=PjlfsNcXfXCoQB7kqZWzC7iAhctnCcgagRizfAU7r48aPgYoJLQYiRw/OroAtyeIWe
         s4o+pYISmYFeYQI+jZ/snvZvEhSN/0krlFCEkMpJ6b7kQU8B8mltD4Hdb/lhLBw/yvU3
         dtB7hl2l64LDXQnDfIdWsnmXvN7Kpe7v/RR7ii9onJIbx4IFu2cAjNnoQQRBJAoUiJIb
         YQBUBYjQobYB1ev94PUaVOS72ocRkp9vvtE/x7QQz5o1GXLaV/0nNgLOEe+F45I01rWL
         GPE8oGJhiZ16ZGU8KHN+C35nbz8W4Eg82Ui023KDX0F0PH20obp2nq5vTX/2Jj3YK4t9
         dNBw==
X-Forwarded-Encrypted: i=1; AJvYcCUoopJnb/ZN7LgS/U+DJ67hpk+hJ5Nnhm+3Ga3w6IgGropX1Y+/QLrz9Lv+DS6TcaUvwzT4Rus=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaYsTkghDW6/H9sfTQEUQlM/hmIcfTPCIEFCcdgTfNJeAjDSyT
	e8mSagGxJPyLpAZlEV0WOahNnwiL/55wsBYH4blTb0g3q8RuTE8589WG0zXW8ClEkg==
X-Gm-Gg: ASbGncurR4le//fogodVaP5fhq6GMSjXQjyZKjqiBDVczmBYrouWjzGtfCbGmhTKgCc
	xCpoVlu0OlxRV51vmLgRsrWmpXRHYNVhAmGEsMuxBABY0TD9nlFgjAHumKaZLdnKM3Zk58FLM/d
	w5mQHFvqI1ahLO3KDygDtHjelLR0gARQPVvhW55416YvaDydOukjE3KeJiXpbZVeZ0OjAVm8T5X
	ajVpy/+uS+1ZdzqDbUAK+s1pMN2bHqB1dNYjXLggX5EBjutTUnUBr62/zTk1QwgSMsgVICAuo6r
	H4h9UilCbMA6ZZiPtbsCoME8cU7QMgfylMXrFmN48pnrv+ymqVaO9mtw++2tBAIrlg+W2/my5Xa
	71N7MlsWGUbh4zJiC/SVomsvibq5LQQ+txg1csM6sBZthyA+Bxf1VxUtwn4aRf2g2SYWv3AX2vx
	/8IoqK
X-Google-Smtp-Source: AGHT+IGptLchfw5sfmOjEPtY8r2qXSKc2v7A8C2EV7ihJJOKFikE7Xpor1boUUPU/n3AR1zmFBHKUQ==
X-Received: by 2002:a05:6000:248a:b0:3e4:f194:2887 with SMTP id ffacd0b85a97d-3e6462583c1mr8562991f8f.30.1757434479398;
        Tue, 09 Sep 2025 09:14:39 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521c9a2esm3528836f8f.14.2025.09.09.09.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 09:14:38 -0700 (PDT)
Date: Tue, 9 Sep 2025 17:14:35 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/24] tracing: Add reset to trace remotes
Message-ID: <aMBSa29ev0BNgr5R@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-5-vdonnefort@google.com>
 <20250908193757.079aae76@gandalf.local.home>
 <aMAZMaZJ1_Eny5Ku@google.com>
 <20250909094028.3265b751@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909094028.3265b751@gandalf.local.home>

On Tue, Sep 09, 2025 at 09:40:28AM -0400, Steven Rostedt wrote:
> On Tue, 9 Sep 2025 13:10:25 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > > I wonder if we should name the file "reset" to not be confusing to users
> > > when they cat the file and it doesn't produce any output.  
> > 
> > My idea was to keep the exact same interface as the rest of the tracing. I could
> > keep that /trace file for compatibility and add /reset?
> > 
> > "cat trace" could also just returns a text like *** not supported *** ?
> 
> If it's never going to be supported, I rather not add it. It not being
> there is a sure way of knowing it's not supported. Just adding it because
> the normal system has it is actually worse if it doesn't behave the same.

If later we extend the meta-page to support non-consuming read, /trace would
then become useful.

Another argument for non-consuming read would be to enable dump on panic.

But I understand your point, it might be wishful thinking at this point.

> 
> -- Steve
