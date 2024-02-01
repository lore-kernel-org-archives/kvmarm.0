Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5561D8405B
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706808765; cv=none; b=i1tpPDsLCTlfuIdJvHjnX3Ezfes0jR7xtnVAG9LGCYxRLWd4GZTgvB8EuxawWHGB//viCSpDjWV3izxSaDvxxE2efdF7V8dYyqSDTa3GJP49LhvsiDc5f8SV3F1coEw/nSTpscjzhHz8kdBCyvFoZc5mpexgfCCuLPkfZpJeB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706808765; c=relaxed/simple;
	bh=MYQeElrn6RP0xY9MrtM5r3jpd3C3Jxbd1CwNKrqS/qk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AmYtZi5A7f0uJ3k1C31DRhlqCNBlDvWm7qlk0RlZTjGvpxtMVNJkuPPd1DsubujXjYt8YNF0CaVp4c/8AIghMy2qrXo08bNEUPVtgMQQfUkm47UpK6cpkaFMMMiwG9INB1aPYotQuNVqZbEWzhwHIB6wNWDxtL46S4bjIelv0vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vREwqfrd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vREwqfrd"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso1295223a12.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 09:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706808763; x=1707413563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UD3/+3gzKT8fI1Ep9NTewT3g/cKMHmpNqtb0XSkLImQ=;
        b=vREwqfrdhEW2CGXunI2R2x2Ona7FvlmXwYx7pq0b01jT431iCDA+Gfft0/SGeNBW7W
         UuYr0GuBhOvCTQBQVXpwMLGSbKyd1IsFzRHgHUbCn+E3t2VKOGm9euDmi8WIJP1Xcobp
         C5XSqSdXok3LQm5M2WKFVdwjByoq422T3cDGmN5/bCHkPXB5t4CNSYeclngOx05eoAgy
         QpoNTRRI69jOvkqMyFmy0ZF74xrSJFJwUr8xa1MXR2jM52lhC40LWtJq8WFDy+VBo6VM
         4mO48dc/26e4M/udFuzK2CsvNZ631exS5ifPuOW/PnZX1zo+HpXWRGCv4/Thzq7X0X5d
         q8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706808763; x=1707413563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UD3/+3gzKT8fI1Ep9NTewT3g/cKMHmpNqtb0XSkLImQ=;
        b=G7QGKE1i0ZwMUWLI0r+R4BTQe8/8iuzhENXJVE4JdqcRpy0fmIU8ZUjNW+H1Ge0Phy
         B4uooUmHJs584H3P1f2XIz9OfAYHLra4bMQSz8tAq0MCmj6Yl8CQ/Afrs2Xqwf0yy7j0
         5vRaI1k5CFSQe6wfE0DAXkhhElFsokUjxZmz0bTNWUEcrHfeOl1hHNrWrt5VIJfACc61
         wCpEPRGKhWamo8TTWOQ75UjhVR77WACw+j8ano/3dxB7i51iaALXjz5sVQEIy53dGV/c
         7QDM377UMXYtgSqoZnGhWZKwZY3qadyqwTsXIyC28pjDyNjFSNlBbEVIPpYx0UJTkeAE
         coFA==
X-Gm-Message-State: AOJu0YwSVE8h8wZNguWYAr95gxn7kIq7pyMbTZv2ncrwdItLhs5/VVQp
	H3/jdoBo0tueHFf6USCWJwzMxQGctMiuJ8v5tJdLO/0A7TLiXnCxHEOcWQAuLWubja1PuDt8W72
	gjQ==
X-Google-Smtp-Source: AGHT+IEafkVK8au1j33821EYsvbAmBAx9/jzn80P/T05OUbLplyNFemMOeZYcdkVNujKPjTr+JBvyfZFE5k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6641:0:b0:5ce:474:352b with SMTP id
 z1-20020a656641000000b005ce0474352bmr12944pgv.5.1706808763674; Thu, 01 Feb
 2024 09:32:43 -0800 (PST)
Date: Thu, 1 Feb 2024 09:32:41 -0800
In-Reply-To: <510f3534-b076-4d23-b4b8-361c1f872d57@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231117052210.26396-1-shahuang@redhat.com> <ZbQVRX3V1P-ZE2Wf@google.com>
 <510f3534-b076-4d23-b4b8-361c1f872d57@redhat.com>
Message-ID: <ZbvVuciX3HENjxQi@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix the dirty_log_test semaphore imbalance
From: Sean Christopherson <seanjc@google.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 01, 2024, Shaoqin Huang wrote:
> > >   	/*
> > >   	 * We reserve page table for 2 times of extra dirty mem which
> > >   	 * will definitely cover the original (1G+) test range.  Here
> > > @@ -825,6 +832,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >   		sync_global_to_guest(vm, iteration);
> > >   	}
> > > +	/*
> > > +	 *
> > > +	 * Before we set the host_quit, let the vcpu has time to run, to make
> > > +	 * sure we consume the sem_vcpu_stop and the vcpu consume the
> > > +	 * sem_vcpu_cont, to keep the semaphore balance.
> > > +	 */
> > > +	usleep(p->interval * 1000);
> > 
> > Please no.  "Wait for a while" is never a complete solution for fixing races.
> > In rare cases, adding a delay might be the only sane workaround, but I doubt that's
> > the case here.
> 
> If that's the case. I guess I should keep the current solution. Except you
> have any better solution, please let me know.

Unfortunately I don't have a better solution, and I don't have cycles to stare
at this deeply to figure out what how to make the synchronization rock solid.
Sorry :-/
