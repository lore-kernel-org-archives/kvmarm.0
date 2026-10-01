Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802E027FB0E
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860327; cv=none; b=t7eQL8zUKnyuLiJwIDIAdQdU8/BpJ99Xf+kMCAVzYH7FdYBpyqLM73Ac0Ce1ijJWfLMbCVY+YR3xriSJkIxMMaGRGfhZMY6/ORKlY4c+prI5lxMvxvcfuNTG3Chs2Jg8JlIBxzGLTWrZsAhixgToTdrrHk3hqdZ/ETU8VYYxKao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860327; c=relaxed/simple;
	bh=qPY8F3aZkZdZdkDBNIxoLwQnRsRRPFn4RgfhzHvta1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TIclbQTfmREzeXlCC6cBi9Tv/7yOXVaE086BYo3d5WYF1Q8S1d0r6Z9FTVGmIaj7oacOWHlqV18CbZHXftBOpk3jSbvC3nrYI0vHM36VGfTInGtW5YQMYfm37NmPu9aJln6+ISkwy1ekLKsPVcXe1yzagml9SW1tbm6JhBIn/kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Msd3zhyk; arc=none smtp.client-ip=95.215.58.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Msd3zhyk"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qPY8F3aZkZdZdkDBNIxoLwQnRsRRPFn4RgfhzHvta1I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790860322; v=1; x=1791465122;
 b=Msd3zhyklXBYTy59gxp4rUSU9/AT9p2o/H1EzjA4AB8R+bmKptnjd1R2CL29r5WML5n6ymWj
 3E5uPo5wvzlt/8mH8Sow9LQbvZaRkGcQEuiTpH81BNDt9rElikN0wm5TRtDClDbCkwFgrdl6L9V
 xJz8W1dcSl/xP1oOZXW30pIE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2603e91e3ac8249c;
	Thu, 01 Oct 2026 13:12:02 +0000
X-Mizu-Trace-ID: 2603e91e3ac8249c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5ba40832934so6940e87.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 06:12:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxMaxZnYPEvtPnUAoUZJ8EO0aWzjg73vtDtHn+BuOt0jhYAtX1vSPrALn5YrJU82n4EiHMjzqo=@lists.linux.dev
X-Gm-Message-State: AFq9FYLPTg63roQl3rl6S4fJNEf2hvGvFMvXIzexn/kIINNVL8WQGDZL
	FBYhwErCbvGjhaYoxJHdVuDUQs2J/FnCchT57qe9VAfNBlBKjaGQelMvvfjz+E7GcTQm58TMnDE
	mQ+ygL+f3o0tSEiX30EkQxNaZcuvD5FySnazENbLJ
X-Received: by 2002:a05:6512:6411:b0:5b8:f20b:350c with SMTP id
 2adb3069b0e04-5ba43805629mr146508e87.3.1790860321116; Thu, 01 Oct 2026
 06:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-11-fuad.tabba@linux.dev>
 <arK1tHUEJsCQEKzn@google.com> <CA+EHjTx+foVF4CRU5D8bQv8bAqDphMN12UrV+_doUryn2ow6bg@mail.gmail.com>
 <arTfjgvZIhmXLrw1@willie-the-truck> <CA+EHjTxe0JE-tCX4YcEEafdnxjuZLj3EBucZfZF0HCP2PQAekg@mail.gmail.com>
 <arUUCFHamX1nOrB1@willie-the-truck> <CA+EHjTyWDvVc4B0mF8+N3QJ=gVPGEY-pxPGZWuTLK6Y=PZnF1w@mail.gmail.com>
 <ar5Y2Usv-t0FggVA@willie-the-truck>
In-Reply-To: <ar5Y2Usv-t0FggVA@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 1 Oct 2026 14:11:24 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz9DYGa0nZKRFL9ADW6QteugRyepdvE0Q6qJRUsbR-MYA@mail.gmail.com>
X-Gm-Features: AclHuK91vl67_Aq7uOGWFfqQ3FxG97CsxRtiah5XT6CIp7Z_3LPr6IKz4T7UkZM
Message-ID: <CA+EHjTz9DYGa0nZKRFL9ADW6QteugRyepdvE0Q6qJRUsbR-MYA@mail.gmail.com>
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
To: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, catalin.marinas@arm.com, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Thu, 01 Oct 2026 13:58:01 +0100, Will Deacon <will@kernel.org> wrote:
[...]
> For the benefit of everybody else, we had a fire alarm in the office
> yesterday evening so Fuad and I sat outside a bar with a beer and a
> piece of paper and went through this together...

Memory ordering is hard work...

[...]
> If we address (2), then I think the sequence becomes a little easier to
> reason about. The OFF->ON_PENDING transition on the requestor looks
> like:
[...]
> which I think makes sense. WDYT? If you agree, I wonder if we can
> include a comment similar to the above in the code?

Agreed, and thanks for going through it with me (and for the beer!).
v4 already clears reset on the CPU_OFF path rather than on guest
entry, and I'll add your sequence as a comment above
pkvm_reset_vcpu().

Cheers,
/fuad
