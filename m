Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B79B39FE6
	for <kvmarm@lists.linux.dev>; Tue,  9 Jan 2024 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oBI9zjTm"
Message-ID: <c90a3fb4-62b7-5642-433a-b0cfb41d6992@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704814633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2evywFWPb2xNlXVO4oH1NtWr770tOPifnahzcG/NYrc=;
	b=oBI9zjTmVHUBVQEtwN4jAv54EOPokxBmG3n/S0VOXFEjAo50Vz0uf0IFvdDf7pekN/4H0i
	ZFwAVN8HI77ySlnCBZtmAMxaxqnAMaX3y+8GWT0cXVhIBCLxvTUHoxcNw4VOht2h90vpOH
	jkPqnpeTiqGDoYTXunHRDASMqZsQxjk=
Date: Tue, 9 Jan 2024 23:36:36 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
Content-Language: en-US
To: Jing Zhang <jingzhangos@google.com>, Oliver Upton <oliver.upton@linux.dev>
Cc: Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eauger@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
 <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
 <ab1337bc-d4a2-0afc-3e26-0d50dff4ea73@huawei.com>
 <ZZx5y_iy9kXg47SW@linux.dev>
 <CAAdAUtie4GFKAPhk4wDWnEmSOzWF+X-6eHwS79169JRv_=hKdg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <CAAdAUtie4GFKAPhk4wDWnEmSOzWF+X-6eHwS79169JRv_=hKdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/1/9 09:31, Jing Zhang wrote:
> Hi Zenghui,
> 
> I don't have a Cortex A72 to fully verify the fix. Could you help
> verify the following change?

It works for me (after fixing a compilation error locally ;-) ), thanks!

Zenghui
