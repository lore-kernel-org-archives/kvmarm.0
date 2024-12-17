Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D1C1F4726
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734441264; cv=none; b=u9GNsmvd0/TndDxgjieVWq9Dyifwv9l1SneFs4bnpOs9P/Q+77bynvUCSmYYuRmvPhUBdd3sm8JahCe226wxNIC4DfoJP4Be2iq9IBQ528xa7RVITcxQ7bgvGXFsJdmBF9Omw7zZ8QwiTV52suq1xMfHb5bDqdGX0NtRzL+BMKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734441264; c=relaxed/simple;
	bh=ZRwEOgnrOBB+ZQKu8dQe/bgdimJsM43RIUjPzjawoV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qj/xR/RIoQ65SV0YRZn+MgrtOjSjyoFXpcLtT8fiwCOKAy8AZZEB/1nxnWpDSvwc6VQ69rcWS+P00qWnDwksNJVGNWbny757O2VSnDhSj5Rp2pd++fBYSf9Kv++GANFbiqejHIS18AsuFI+sizRkgwfGoAmV7yED5DEgMofQDf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqWGIqzm; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqWGIqzm"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so1885961a12.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734441261; x=1735046061; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRwEOgnrOBB+ZQKu8dQe/bgdimJsM43RIUjPzjawoV0=;
        b=eqWGIqzmlf3y3IwOgcENM915lQFhODskXqwMH3u2bB7c5i6YKBw8BpCcgEmN9aaIwS
         rFhK0tu/cSKy9KQh87YB1iE08aktFMVs8FKzfbopsAFgPZ9z9azD5n+YGrr1UHxwhD5m
         OR6XGyKogoY68A8CSFpqvdcgK4p8WSDv68+AfYDVKsiQ5enGfzD4cxHutHt6BJXTwSBt
         4o1vNBmCUoapCYH7CMAJAc90YSIXnBuhOKl2KjOrpeiLnXF0jGxsVWlRnUt9YmhKwWBJ
         v+qN/FHJ2IxWpw07T2tD34KmzDC8wh73lel2yWRWv4ZJc7GqI1FHPnow3FdTKqsbEGEB
         mgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734441261; x=1735046061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRwEOgnrOBB+ZQKu8dQe/bgdimJsM43RIUjPzjawoV0=;
        b=RZFRs9kTfbUSDSMsUK8QC7eHlxAVjXyoB9avI+8lHJ3+v5d3/IVFsf2nRrSwWjJaju
         aGEjr+8o+I3d1Z0Sga8t+FgkOewyFOBVdWvKAinPFx5B2qfLLWeVlfwLNskDQ57xSoju
         lveuePKtaSRA2vZwRcnVeLjoVhlLLlxjXwyhodcTkU0r+H1iuxoHlPkDSV/s5/9bIRIL
         w26tG7/YgKggqj5PYDnmJJo4l+q/8CrJSdFqTLbvoerBAy8WUjF790xPClPpnVOdVDbo
         dWJOeCY25i+C7V49qJFY2X7m1juSH/DYCaYArFBSjMPYz2u4koRm3MiOLETdtzI3kC/S
         6tMg==
X-Forwarded-Encrypted: i=1; AJvYcCXCLDUvWoUA7UkfbOm9WxQ2TLRSQ5Hx6EY/nPL85jhm17fX3bDfXxvLBOF6GpuLr4ojbPxvP8s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKARCdHDz7u4DgF7fQ5csWVuSU0cXC73aIZpJ3WktHNy3YKpDH
	eW/YrIv8Ti6viN1WT2xAjnU8lm+MgtZpvo3qvKUzJqfcDQwEGPgqmPr/VOaEgQ==
X-Gm-Gg: ASbGnct7hqYvRbkyxBp1v0FSBRxojUnQL5PDrpPk/saZX+3e253cF2pD9JaWGTf7zjd
	qAOoG8WQw720NHwnp6aLJsc5C0vlrlyaoci8/KtCDMMsy666Wi/YWoz3zSE7vKs1C8JCDDM7Ryu
	S3b+6XCn8frw2DQbTEQN0yIyBIJFquSzDmEs6of08pNrQ/a+cB9OYFAjvsy53UsMdD7LfQofSdt
	veszp3g2xvSFZh5DPB0RdqAJhkO/CfDiyPd0mMXTPUcla8rWfxFTmqO1jK68HGr8uZQnRKwZuhB
	awq9BqVSjU5WTEI=
X-Google-Smtp-Source: AGHT+IH5mltElk1JWkMMGj0bbNEjRXmDJL8qqfF7HW7DZRJ9qkEkQrLz3PI3FH4dCgH5rmzrjIPsIA==
X-Received: by 2002:a05:6402:3705:b0:5d2:7270:6124 with SMTP id 4fb4d7f45d1cf-5d63c3aac76mr14360142a12.23.1734441260795;
        Tue, 17 Dec 2024 05:14:20 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d652ad19ffsm4284077a12.24.2024.12.17.05.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 05:14:20 -0800 (PST)
Date: Tue, 17 Dec 2024 13:14:17 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/18] KVM: arm64: Introduce
 __pkvm_host_unshare_guest()
Message-ID: <Z2F5KboZewSDClKg@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-12-qperret@google.com>
 <CA+EHjTxRt=XoCZbRLE1UjMg4bzgoLYD9Lh0nzmjvPZ2Q4xQOkg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxRt=XoCZbRLE1UjMg4bzgoLYD9Lh0nzmjvPZ2Q4xQOkg@mail.gmail.com>

On Tuesday 17 Dec 2024 at 08:53:34 (+0000), Fuad Tabba wrote:
> nit: This parameter in this patch, and others, is sometimes hyp_vm, at
> others just vm. It would be nicer if it was always the same.

Argh, where specifically do you see inconsistencies? All changes to
mem_protect.c should use 'vm' consistently in this series now.

The code in hyp-main.c does use 'hyp_vm' consistently however, but
perhaps that is what you meant? I did that to follow the pattern of the
existing code that uses 'hyp_vcpu' in that file.

Thanks!
Quentin
