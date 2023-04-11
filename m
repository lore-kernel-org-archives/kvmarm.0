Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CC35388
	for <kvmarm@lists.linux.dev>; Tue, 11 Apr 2023 09:08:47 +0000 (UTC)
Date: Tue, 11 Apr 2023 11:08:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681204125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I2iC8buvK2tS8ozL9BHGlo/Sy4UT6qIVUL5c6wk4p6g=;
	b=jDlTpk0mHI9HGFG/mMYsZ8feUXZFsTYrXMBV5wrpq5gBMwvb/D9qBQrkCPFRqNvyAJEb4W
	P4y8LBz10RyPFh4MBpBmxUQknrrQybLiS/mbE8byvPCvvIGCxYHg6xrzoKogdNXTySydbl
	/Ezp9qgwjnJyILNj90gjOzfVQUX4280=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev, qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 0/7] MTTCG sanity tests for ARM
Message-ID: <hlno75xnob6jwbpfzwbwsjje2ujgfzw5kwvwmu2627obkmpqk2@dtcvgno2dkge>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230321152649.zae7edlfub76fyqq@orel>
 <87mt3erhe3.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mt3erhe3.fsf@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 11, 2023 at 08:43:49AM +0100, Alex Bennée wrote:
> 
> Andrew Jones <andrew.jones@linux.dev> writes:
...
> > Someday mkstandalone could maybe learn how to build
> > a directory hierarchy using the group names, e.g.
> >
> >  tests/mttcg/tlb/all_other
> 
> So nodefault isn't enough for this?
>

nodefault is enough to avoid running a test with run_tests.sh,
when its group hasn't been explicitly selected, i.e.

 ./run_tests.sh

doesn't run the test

 ./run_tests.sh -g test-group-name

does run the test.

standalone test filtering is only done by filename (but
potentially pathname), which is why I suggested we someday use
the group names as directory names. Anyway, that's future work.
This series just needs to ensure it gets its group names right.

Thanks,
drew
