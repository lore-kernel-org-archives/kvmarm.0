Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E7C972
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 15:41:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679413286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nu6AEzpkLDRpJUdYVJfCsu7tNGyF6kVZqp6PpNwWiyA=;
	b=UlsPM1/EpPR2eQKlMS3xuy3JKBsxEgoxKdEhY8lnmeshrB1cyHoOvq1CxscKvXoWpzwC3A
	MMGupx+j5N6ZdDjphn7Q8DKC+qTktN1kN15T2kwQ/iX9P4qcYYLul52S0909SXwjGc29wK
	2qCYzB54DYr/0/9jZ0yUTFXuLbxscxE=
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>,
	kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Clean up the arm/run script
Date: Tue, 21 Mar 2023 16:41:22 +0100
Message-Id: <167940943515.820115.8164556248057369265.b4-ty@linux.dev>
In-Reply-To: <20230303041052.176745-1-shahuang@redhat.com>
References: <20230303041052.176745-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 2 Mar 2023 23:10:50 -0500, Shaoqin Huang wrote:
> Using more simple bash command to clean up the arm/run script.
> 
> Patch 1 replace the obsolete qemu script.
> 
> Patch 2 clean up the arm/run script to make the format consistent and simple.
> 
> Changelog:
> ----------
> v2:
>   - Add the oldest QEMU version for which -chardev ? work.
>   - use grep -q replace the grep > /dev/null.
>   - Add a new patch to clean up the arm/run.
> 
> [...]

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
