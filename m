Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F256515A6
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 01:44:57 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-545d027103eso162485317b3.5
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 18:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680227097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcnJNCHDCGQ7Pzom/y/MQEMC0VEcznZRpNuHkAP16dM=;
        b=M/Dq0K05dn7RZdEyBco1zZW8o9aWbWD0tOGYp2aROenD9B8zG0YkXNU+ypXcmNaQHy
         4te0VdM4kG75aRgDJAiNeipUhfEk+8e/2sx5TS12tTIKnwevTbmQxo+lHWm8c4GqVIme
         9obizM0C3ozNmYHsi7lUhQIGaKT/Br4nuLulq8WoaCHOkuqxJMA1bY+CMXCC0ew5OUZ4
         1jdQ0A+60hb3BK31NK4oiYIATEqSpKYaYoTbaF3+E58KDNOd+GbOm3KRIRxTxJKRucQs
         fJJk6ss0ykBavcFxwDBDlUhiJ9dG27uWdOFRP7shyzkO7Uda44T+RDaamnaXQVhGcf2m
         ufIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680227097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mcnJNCHDCGQ7Pzom/y/MQEMC0VEcznZRpNuHkAP16dM=;
        b=F4RN8CV6+F0CIlxnCQpNEocoXA9/0opw+ZneUasTf/MbR4M1a2FtLBjGyIW5DfamPw
         7kN47r4WaVZa5uE1k8IxGeMKNw1T9+8aUGVqwOw9DGOa0e4zZXY6HfLkl6nYuCCY9b4J
         ZlQKmn33wEsWgzX+XcFAmqTD7l5QM/IZ5XARUSb7cqxEd6tAk9nub5kEJ4rRcHO03CsV
         hHmnmpl4JFGTVOCALVS4IKLN/degSfJ8fo5IXnjirOtFcq4eAGDsliZv48IlCotPCqFw
         jIkvh2EKvt9zfBbsApId9ONTIynNDHDiM3XzNvgRLBMpmDHOXHmfVTS2rg5XssSK97vj
         KWGQ==
X-Gm-Message-State: AAQBX9dVrHPYhePlcozu84guge88svshcK7yPM4mBn6HgLpWYvZ7jxG1
	yMt+rA9M2pcDCSeYugEcpR0NtPUT/O+o
X-Google-Smtp-Source: AKy350Yd56UldAkJl7asDkNCi90KnSNtQkBy2kVHq8vFVuOOr9KiBt3/jvgItL1ugb+qYv+7kMO0tDmyjIK9
X-Received: from davidai2.mtv.corp.google.com ([2620:15c:211:201:c162:24e8:ec5e:d520])
 (user=davidai job=sendgmr) by 2002:a25:344:0:b0:b27:4632:f651 with SMTP id
 65-20020a250344000000b00b274632f651mr12517637ybd.3.1680227097054; Thu, 30 Mar
 2023 18:44:57 -0700 (PDT)
Date: Thu, 30 Mar 2023 18:43:49 -0700
In-Reply-To: <20230331014356.1033759-1-davidai@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230331014356.1033759-1-davidai@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331014356.1033759-6-davidai@google.com>
Subject: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
From: David Dai <davidai@google.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, David Dai <davidai@google.com>
Cc: Saravana Kannan <saravanak@google.com>, kernel-team@android.com, linux-pm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add devicetree bindings for a virtual kvm cpufreq driver.

Co-developed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: David Dai <davidai@google.com>
---
 .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
new file mode 100644
index 000000000000..31e64558a7f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/cpufreq/cpufreq-virtual-kvm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Virtual KVM CPUFreq
+
+maintainers:
+  - David Dai <davidai@google.com>
+
+description: |
+
+  KVM CPUFreq is a virtualized driver in guest kernels that sends utilization
+  of its vCPUs as a hint to the host. The host uses hint to schedule vCPU
+  threads and select CPU frequency. It enables accurate Per-Entity Load
+  Tracking for tasks running in the guest by querying host CPU frequency
+  unless a virtualized FIE exists(Like AMUs).
+
+properties:
+  compatible:
+    const: virtual,kvm-cpufreq
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      cpufreq {
+            compatible = "virtual,kvm-cpufreq";
+      };
+
+    };
-- 
2.40.0.348.gf938b09366-goog

