Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208036196C
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 21:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785966000; cv=none; b=lu5TPDabs1sRNJo1ElPHlODegpQLbAfkjoeIcMi7qk+35oev0DX71YdHR4A9ZbZ91QzGLFPGZJ4ytIs5vUGgQ6TEdzUR5mnBrgrZ5Cg4qhxC62fq1XkX4MongrvhPTeTE9OhrvESk8WljNCSK8zhJ44uR2Zkm1XL/yIdYLDJo8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785966000; c=relaxed/simple;
	bh=QQbWVF9MkffKPNOm3Xp+x/HSUJzikj0qawl/MCEpm2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6YLx5nFQiisJFhMUIQfDE/xYioEnCRo5x6ifR/EiGa5Hx9H6GOH79JFJMgXZpdro4ihOBJsc6EnRWh3bxbEiV6lBEfVe1FWu7JDSmoBrgFTrHz1WJ63xiIJloNoAmGq5G+ms69hI5yk1GSGsB53eNmTPhtWEPkGgh3sWHTKCBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvK80u2w; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvK80u2w"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47fe2d179e2so980140f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 14:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785965997; x=1786570797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yOlBr2Z6ScmE+dhp5/f+kPQyir1jOxNY4C+TyOhoSGw=;
        b=GvK80u2wTZleW7bRnAqUQb7TcMV63DuzfIpZZSC7iN7iYgXIPZbRSYun2RVjz5Vhfh
         /EfZ6L9bKLKErFmbaerq7PF7QIcX5qLsWUu+Q7Mm3ZidT+AhBsoQ/bHJiyULlCT4fnvu
         HuYk8sOkFNOngkyKfIOm2uAEi3mW/Xsug5QOk44kZM5c0/CliaqXKruuoMLcx7vYvaUf
         bEV4zjCLYvT42LKg6758LG6SkmpyABZTqVdPTMfyNAEZJ/N+k3RJ3VHJkZpi9agJHAVH
         bDjvlHYn5rB+S9bwyDcukoYEAI6J+GhF6GxrD2nGSfQ+TxwqPordYrDwk6BLfUqdxGzR
         k0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785965997; x=1786570797;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yOlBr2Z6ScmE+dhp5/f+kPQyir1jOxNY4C+TyOhoSGw=;
        b=eFDbqCFGYfxJcyEsLcTm/EuOXtVZr1NgSfEbA6PTP+aC8qVKkwfz9XuYQdcSJ7HiQ+
         406orEDIzG1YhXBqbF2CTQLCxB9UQeKC4mFFnIMtujvgyh8II6woJzLxKYcKcjGk75bn
         97sWOXTrBeEIphghhQN6zQdEsfG0+s2XqYBt+iPsobOHsAkv7jtC9WRmIT/UTobot5/k
         Ve3T9UNo4agivf4s9yv/gmnOPqf8p/tCCGMHl1g2fJ2AoqQm1PzNdCkwKaWv+9LK6hEs
         UwLYPrMgl5HS8NpYJB6q8od8msa3dvklslMrK42T3+9cY1OjOGnldCryMMZ/m2CLQ78a
         UZKA==
X-Forwarded-Encrypted: i=1; AHgh+RqLcyZQlD1f2UUZeXy2pmr4zxeqW/KXJ+bWUsVUa4nv4KU+0dvLW8o5CLgF4LICqg5FvZkogy4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOn8OIRdEpmItXr7UixeVgbWMi8EW7zvl0gYeW09HaFda2Wr45
	kKHSr19ryBLxrpfdQUkqRqtwhgrApospTroihCeeofFUhiEmxoopQrqV
X-Gm-Gg: AR+sD11MR2nxd6xPbg0vxi6CRR2Cu6Uxn727jsxqeXCWnXHw0OG6x/y2W2lxBTvqVh9
	RnA1OV64+evAG2fww6afqhFid/PQ309L0PYKZYE4MlqNFVpx97ae+OPn9uB84K+iWwtO26pY1ak
	q0LFPa6c9CTkkwymnqq0TISGC0OCTmPCAHmxd7+kBZCtuoiFB6PrIBGq36YNWZHzwoQfpFuHlZF
	smZvk4qdIEe8uS/idfMmFYJRHzLDSSDiFAR2HFB9FxmUBclOSdcb0C1Edz19QCtMewGmEiKG4Qa
	+iuimfFZH53g1ESfA0sImurkBWqqr3j6Ywti0VSLD9GZcS/f2fWAK4eSaKghDsiHgAbtVIi009A
	6Um/J0VNC6nGBZRqi7cAhM+9F3ghej5lYLXqmRKgvACHL6MrFE8pAnsrWQMxDI1PT8x8gUzlf14
	i1onPksuvXLDAe2E3KaACjCL9VFvmIHkz3wWMJ9Zc6V6AB+ge/uJIu/IVhg0aANS215eFoikkHC
	laO2+DWoyMK6cRt4STDcaNcOg+wFLiZdWmxbuqlJLUnRrxUdT1G0bG6kIuU8z6b4yky3X9J+CLG
	3jq7+D9LjO2qlH4bV766sWC2gjvH+k9plltL2XnA
X-Received: by 2002:a05:6000:1863:b0:47f:5371:1b15 with SMTP id ffacd0b85a97d-47fec63491cmr14018614f8f.26.1785965997040;
        Wed, 05 Aug 2026 14:39:57 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-095-114-073-248.95.114.pool.telefonica.de. [95.114.73.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79b32cbsm568073f8f.10.2026.08.05.14.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 14:39:56 -0700 (PDT)
Date: Wed, 5 Aug 2026 23:39:54 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, grayhat@foxmail.com
Subject: Re: [PATCH 1/2] KVM: arm64: nv: Allocate the shadow S2 MMUs
 individually
Message-ID: <anOok9XvLMNX_Aqu@gmail.com>
References: <20260803224405.41468-1-kmehltretter@gmail.com>
 <86mrv2arf2.wl-maz@kernel.org>
 <86jyq6aq8g.wl-maz@kernel.org>
 <anJcUNlnNmP-mKWH@gmail.com>
 <86ecgdaupe.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ecgdaupe.wl-maz@kernel.org>

On Wed, Aug 05, 2026 at 08:32:29AM +0100, Marc Zyngier wrote:
> I'd rather keep it on the VM creation path. This is VM-wide data, by
> definition, and given that its size doesn't depend on the number of
> vcpus anymore (we allocate the maximum once and for all), it is right
> where it belongs. See the untested hack below for the freeing on error.

I'll send a v2 with this soon.

> 
> > There's another issue in the current code: the ptdump debugfs file
> > keeps the raw mmu pointer as its private data. I would add that to the
> > commit message.
> 
> Why is that a problem? With this approach, the mmu pointers are always
> expected to be valid, irrespective of the allocation pattern, and we
> only publish pointers to the dumper when the S2_mmu is actively being
> used.
> 

Sorry I was talking about the old implementation. Array reallocation
leaves ptdump i_private pointers dangling.

I'm dropping the selftest for v2. It was a useful KASAN trigger, but is 
not a good fit for the current suite.

Thanks,
Karl
