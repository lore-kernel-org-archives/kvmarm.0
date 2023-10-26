Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8244F623
	for <kvmarm@lists.linux.dev>; Thu, 26 Oct 2023 07:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dbt2TG3g"
Date: Thu, 26 Oct 2023 09:40:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698306005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M3D5cMlnquI2qP0OYzHXKIyhSZgRka2jZ9g7TJPNsh8=;
	b=Dbt2TG3gFuaG1sGqJ0GyO4D1lDK5xLT9kv12l5HCB5P0iH9tA7TOuMd55ypIINPIbtFsMw
	Ve4XsEAeHbEYHkmR89uX/hFSTgSFGIhxkKT52MqF0pg5lufp/yrLWoeKM/dKq8dzRa+AH0
	cWtq6BpnUbjilHvWYjSIsUTqgBCG2Lc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>, kvmarm@lists.linux.dev, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] configure: arm64: Add support for
 dirty-ring in migration
Message-ID: <20231026-38a5f6360752b10fdb086adc@orel>
References: <20231026034042.812006-1-shahuang@redhat.com>
 <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
 <9052ed87-e5cf-4d89-b480-54da4d8216c7@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9052ed87-e5cf-4d89-b480-54da4d8216c7@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 26, 2023 at 01:54:55PM +0800, Shaoqin Huang wrote:
> 
> 
> On 10/26/23 13:12, Thomas Huth wrote:
> > On 26/10/2023 05.40, Shaoqin Huang wrote:
> > > Add a new configure option "--dirty-ring-size" to support dirty-ring
> > > migration on arm64. By default, the dirty-ring is disabled, we can
> > > enable it by:
> > > 
> > >    # ./configure --dirty-ring-size=65536
> > > 
> > > This will generate one more entry in config.mak, it will look like:
> > > 
> > >    # cat config.mak
> > >      :
> > >    ACCEL=kvm,dirty-ring-size=65536
> > > 
> > > With this configure option, user can easy enable dirty-ring and specify
> > > dirty-ring-size to test the dirty-ring in migration.
> > 
> > Do we really need a separate configure switch for this? If it is just
> > about setting a value in the ACCEL variable, you can also run the tests
> > like this:
> > 
> > ACCEL=kvm,dirty-ring-size=65536 ./run_tests.sh
> > 
> >   Thomas
> > 
> 
> Hi Thomas,
> 
> You're right. We can do it by simply set the ACCEL when execute
> ./run_tests.sh. I think maybe add a configure can make auto test to set the
> dirty-ring easier? but I'm not 100% sure it will benefit to them.
>

For unit tests that require specific configurations, those configurations
should be added to the unittests.cfg file. As we don't currently support
adding accel properties, we should add a new parameter and extend the
parsing.

Thanks,
drew
