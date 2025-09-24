Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8820330AABE
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.72.182.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758727758; cv=none; b=StTYENgLv7rbVXKpe2nqnLWk2/FZeRGOzEt6KisJAGfIkCzJ4zeKUI0lefVwTE9RdJX9QOGd/NEULK+JngvM8G+dCkkaMXxS4cg0/Z16e1mwXaKmkUQC2MZJUDzUVI1m2xCuEVNExMf03DNqsMnRtf16qVL4XPZrl80PXib3fEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758727758; c=relaxed/simple;
	bh=xYwtDKmp/Zq0jOTCpG7R8cZcsQAosKrhHZ6MWIe4xuU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dAihQnamSVi0o7Y/LNE+xOrIXDPLGyEeKwPhuzba4dxveHoc0yFkbmTkOyZRooIHTwtYJtYyYjzvxGzjsrOJw8h1lQ7BU1i+HoWMh6ZQzsZLmhVpdDl1KmWxpk35k+wUcn0l82r/qiWYDRCdhXMeMbYIfSM71z00PJab7JGwR5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=d/v0uJyX; arc=none smtp.client-ip=3.72.182.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="d/v0uJyX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727756; x=1790263756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xYwtDKmp/Zq0jOTCpG7R8cZcsQAosKrhHZ6MWIe4xuU=;
  b=d/v0uJyXQ/W/HUYtT07fNKGmTGeZg6bQzA0vkgNx5p3rB1FOYpPTowX4
   Pzf+OpbcF/9qsFVAQVk6/43ahglUyRjPReDg2KxlOBMu4EEQ0FeR6ys1k
   MVeWgRuufTvpbCaz8e2axeJXigANMMYWjg1eW90kTtQNW00I0Xgr0Ar4t
   LVpSekA5bgMlLg+Ak+t6zJSf4qgg4VxzoTm3z3cX8Fvn9ShLf9HINEAVM
   4iQN6J8Plg0H3miUkDQG8Z+EQHl/mz0AVm6SFJ6hqtmIlU/rnLV3aguT1
   jUUlQAYzvnXJGifE9Tme73jXeVnp07ECTwLAVxcRVAj0pmREN5Ck+Rqi3
   w==;
X-CSE-ConnectionGUID: H1Nwja16SO+mJPPrYIM6Uw==
X-CSE-MsgGUID: 6BUVeHZ3T1iQWbqFFphHSA==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2615965"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:29:14 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:7826]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.166:2525] with esmtp (Farcaster)
 id f979d79c-010c-49b7-9e97-d5be296685f6; Wed, 24 Sep 2025 15:29:14 +0000 (UTC)
X-Farcaster-Flow-ID: f979d79c-010c-49b7-9e97-d5be296685f6
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:29:13 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:29:13 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:29:13 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "patrick.roy@campus.lmu.de" <patrick.roy@campus.lmu.de>
CC: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "andrii@kernel.org"
	<andrii@kernel.org>, "ast@kernel.org" <ast@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"david@redhat.com" <david@redhat.com>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"haoluo@google.com" <haoluo@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
	<jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "luto@kernel.org"
	<luto@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"maz@kernel.org" <maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pfalcato@suse.de" <pfalcato@suse.de>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "song@kernel.org" <song@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "tabba@google.com" <tabba@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
Thread-Topic: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
Thread-Index: AQHcLWf7p6lrgf1yqEyGzQxUogXjVw==
Date: Wed, 24 Sep 2025 15:29:13 +0000
Message-ID: <20250924152912.11563-1-roypat@amazon.co.uk>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

_sigh_=0A=
=0A=
I tried to submit this iteration from a personal email, because amazon's ma=
il=0A=
server was scrambling the "From" header and I couldn't figure out why (and =
also=0A=
because I am leaving Amazon next month and wanted replies to go into an inb=
ox=0A=
to which I'll continue to have access). And then after posting the first 4=
=0A=
emails I hit "daily mail quota exceeded", and had to submit the rest of the=
=0A=
patch series from the amazon email anyway. Sorry about the resulting mess (=
i=0A=
think the threading got slightly messed up as a result of this). I'll somet=
hing=0A=
else out for the next iteration.=0A=
=0A=
