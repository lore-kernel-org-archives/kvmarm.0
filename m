Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AFB1EE033
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742992; cv=none; b=huJ8HPQjt+h1XmGz8XUMSzCx2M3nH76LTMoFQ9S3ps6u8vCLhW97PzsGGfflKj0yQbVwKzgJbNBw4rmTqvghVomFChKwrR/lfQ0jEge7+hPjg0BOa8GH+rUgC7IVcJCImjlLBselX97Q9WZNoWkLWPYg3ZaHHeVE2pD61uj4nVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742992; c=relaxed/simple;
	bh=QlzeBozERNkPQN79SySZLVW0aVeHkG0k3mM39lvyeYs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ak82JmL+i6n+eVQQIfsSaD9Iew/OHG/qlvYnWl9QxZGMubPgrMiY9yAD20Ze5eN5XAOdod8iLJxw+cjZ0IKEcUya+Gfyvs2km/RBRFSBRkDu/8xOA+SfajzCUVLgTI1rZTxVgj5r2Ohnfq9wI6IrzGXNntYLlemjkGtEb0NjM3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOU2qX/L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOU2qX/L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749742989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R8VS4oBc5qIirjsbvzZp2wjtV3fOLfCci7p603pObEE=;
	b=AOU2qX/LN/L2wtx64Cxei8V/9u2gDpswUwWPnyUhKJXqOQl2jgE2pboE0GAsuPqvJGIrFM
	O6rGlOfmGvlUvWTTOeqc6G0QcAsyZHNCCK3EN2UW6qivP3vLhW3a2zhEkTsX0/1hgmMbmH
	t0vXR4AmBEc3VqHzcWtGOGvNterDQzw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-CLqA-YKjNrKkic6JNGzYtw-1; Thu,
 12 Jun 2025 11:43:05 -0400
X-MC-Unique: CLqA-YKjNrKkic6JNGzYtw-1
X-Mimecast-MFC-AGG-ID: CLqA-YKjNrKkic6JNGzYtw_1749742983
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F03531809CBB;
	Thu, 12 Jun 2025 15:43:02 +0000 (UTC)
Received: from localhost (unknown [10.45.224.54])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09D95180045B;
	Thu, 12 Jun 2025 15:43:00 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v7 12/14] arm/cpu: Add sysreg generation scripts
In-Reply-To: <CAFEAcA-xDxoRLWZCMrAEeSb3NvyyOPzYgFQbbEzGALujOOG-3g@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250515153907.151174-1-cohuck@redhat.com>
 <20250515153907.151174-13-cohuck@redhat.com>
 <CAFEAcA-xDxoRLWZCMrAEeSb3NvyyOPzYgFQbbEzGALujOOG-3g@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 12 Jun 2025 17:42:58 +0200
Message-ID: <877c1h9da5.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Jun 12 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Introduce scripts that automate the generation of system register
>> definitions from a given linux source tree arch/arm64/tools/sysreg.
>>
>> Invocation of
>> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
>> in scripts directory generates target/arm/cpu-sysregs.h.inc
>> containing defines for all system registers.
>>
>> [CH: update to handle current kernel sysregs structure, and to emit
>>      the re-worked register structures; cpu properties will be added
>>      later]
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>
>> diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
>> new file mode 100755
>> index 000000000000..452e51035d52
>> --- /dev/null
>> +++ b/scripts/gen-cpu-sysregs-header.awk
>
> This should probably have 'arm' in the filename somewhere, unless
> it's really architecture-agnostic, which I don't think it is.

Nod.

>
>> @@ -0,0 +1,35 @@
>> +#!/bin/awk -f
>
> Does this really need to be in awk? Our standard scripting
> language is python. This isn't run at build time so there's
> no "extra dependency" issue, but we currently use awk only
> minimally and almost always for trivial stuff.

Much of this originally was inspired by the equivalent tooling in Linux
that creates definitions from the same sysreg file. (There's another,
more complicated awk script in the cpu model series that creates
definitions for the individual fields.) I can try to rewrite that in
python, but I think awk is actually not a bad tool to use here.

>
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +# gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
>> +#
>> +# Usage: awk -f gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
>> +
>> +BEGIN {
>> +    print ""
>> +} END {
>> +    print ""
>> +}
>> +
>> +# skip blank lines and comment lines
>> +/^$/ { next }
>> +/^[\t ]*#/ { next }
>> +
>> +/^Sysreg\t/ || /^Sysreg /{
>> +
>> +       reg = $2
>> +       op0 = $3
>> +       op1 = $4
>> +       crn = $5
>> +       crm = $6
>> +       op2 = $7
>> +
>> +       if (op0 == 3 && (op1>=0 && op1<=3) && crn==0 && (crm>=0 && crm<=7) && (op2>=0 && op2<=7)) {
>> +           print "DEF("reg", "op0", "op1", "crn", "crm", "op2")"
>> +       }
>> +       next
>> +}
>> +
>> +{
>> +       /* skip all other lines */
>> +       next
>> +}
>
> Generated source files should have a comment at the top
> noting that they're autogenerated and how to regenerate
> them, please.

ok

>
>> diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarch64-sysreg-code.sh
>> new file mode 100755
>> index 000000000000..e34538887dd8
>> --- /dev/null
>> +++ b/scripts/update-aarch64-sysreg-code.sh
>> @@ -0,0 +1,26 @@
>> +#!/bin/sh -e
>> +#
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +# Update target/arm/cpu-sysregs.h
>> +# from a linux source tree (arch/arm64/tools/sysreg)
>> +#
>> +# Copyright Red Hat, Inc. 2024
>> +#
>> +# Authors:
>> +#          Eric Auger <eric.auger@redhat.com>
>> +#
>> +
>> +linux="$1"
>> +output="$PWD"
>
> We seem to set this but then not use it.

ok

>
>> +
>> +if [ -z "$linux" ] || ! [ -d "$linux" ]; then
>> +    cat << EOF
>> +usage: update-aarch64-sysreg-code.sh LINUX_PATH
>> +
>> +LINUX_PATH      Linux kernel directory to obtain the headers from
>> +EOF
>> +    exit 1
>> +fi
>> +
>> +awk -f gen-cpu-sysregs-header.awk \
>> +    $linux/arch/arm64/tools/sysreg > ../target/arm/cpu-sysregs.h.inc
>
> This looks like it is assuming that the user runs the script
> from within the scripts/ directory ?
>
> Following the same command line conventions as our existing
> scripts/update-linux-headers.sh is probably the least
> surprising thing.

Ok, will do.

